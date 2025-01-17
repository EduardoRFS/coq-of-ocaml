(** A structure represents the contents of a ".ml" file. *)
open Typedtree
open SmartPrint
open Monad.Notations

(** A value is a toplevel definition made with a "let". *)
module Value = struct
  type t = Exp.t option Exp.Definition.t

  (** Pretty-print a value definition to Coq. *)
  let to_coq (with_args : bool) (value : t) : SmartPrint.t =
    match value.Exp.Definition.cases with
    | [] -> empty
    | _ :: _ ->
      let (axiom_cases, cases) =
        List.fold_right
          (fun case (axiom_cases, cases) ->
            match case with
            | (header, None) -> (header :: axiom_cases, cases)
            | (header, Some e) -> (axiom_cases, (header, e) :: cases)
          )
          value.Exp.Definition.cases
          ([], []) in
      separate (newline ^^ newline) (
        (axiom_cases |> List.map (fun header ->
          let { Exp.Header.name; typ_vars; typ; _ } = header in
          nest (
            !^ "Axiom" ^^ Name.to_coq name ^^ !^ ":" ^^
            begin match typ_vars with
            | [] -> empty
            | _ :: _ ->
              !^ "forall" ^^
              braces (group (
                separate space (List.map Name.to_coq typ_vars) ^^ !^ ":" ^^ Pp.set
              )) ^-^ !^ ","
            end ^^
            Type.to_coq None None typ ^-^
            !^ "."
          )
        )) @ (cases |> List.mapi (fun index (header, e) ->
          let firt_case = index = 0 in
          let last_case = index = List.length cases - 1 in
          nest (
            begin if firt_case then
              begin if value.Exp.Definition.is_rec then
                !^ "Fixpoint"
              else
                !^ "Definition"
              end
            else
              !^ "with"
            end ^^
            let { Exp.Header.name; typ_vars; args; typ; _ } = header in
            Name.to_coq name ^^
            Pp.args with_args ^^
            begin match typ_vars with
            | [] -> empty
            | _ :: _ ->
              braces @@ group (separate space (List.map Name.to_coq typ_vars) ^^
              !^ ":" ^^ Pp.set)
            end ^^
            group (separate space (args |> List.map (fun (x, t) ->
              parens @@ nest (Name.to_coq x ^^ !^ ":" ^^ Type.to_coq None None t)
            ))) ^^
            Exp.Header.to_coq_structs header ^^
            !^ ": " ^-^ Type.to_coq None None typ ^-^ !^ " :=" ^^
            Exp.to_coq false e ^-^
            begin if last_case then
              !^"."
            else
              empty
            end
          )
        ))
      )
end

(** A structure. *)
type t =
  | Value of Value.t
  | AbstractValue of Name.t * Name.t list * Type.t
  | TypeDefinition of TypeDefinition.t
  | Module of
    Name.t * (Name.t * Type.t) list * t list * (Exp.t * Type.t option) option
  | ModuleExpression of Name.t * Exp.t
  | ModuleInclude of PathName.t
  | ModuleIncludeItem of Name.t * Name.t list * MixedPath.t
  | ModuleSynonym of Name.t * PathName.t
  | Signature of Name.t * Signature.t
  | Error of string
  | ErrorMessage of string * t

let error_message
  (structure : t)
  (category : Error.Category.t)
  (message : string)
  : t list Monad.t =
  raise [ErrorMessage (message, structure)] category message

let top_level_evaluation_error : t list Monad.t =
  error_message
    (Error "top_level_evaluation")
    SideEffect
    "Top-level evaluations are ignored"

(** Import an OCaml structure. *)
let rec of_structure (structure : structure) : t list Monad.t =
  let get_include_items
    (module_path : Path.t option)
    (reference : PathName.t)
    (mod_type : Types.module_type)
    : t list Monad.t =
    let* is_first_class =
      IsFirstClassModule.is_module_typ_first_class mod_type module_path in
    begin match is_first_class with
    | IsFirstClassModule.Found mod_type_path ->
      get_env >>= fun env ->
      begin match Mtype.scrape env mod_type with
      | Mty_ident path | Mty_alias path ->
        error_message
          (Error "include_module_with_abstract_module_type")
          NotSupported
          (
            "Cannot get the fields of the abstract module type `" ^
            Path.name path ^ "` to handle the include."
          )
      | Mty_signature signature ->
        signature |> Monad.List.filter_map (fun signature_item ->
          match signature_item with
          | Types.Sig_value (ident, _, _) | Sig_type (ident, _, _, _) ->
            let is_value =
              match signature_item with
              | Types.Sig_value _ -> true
              | _ -> false in
            let* name = Name.of_ident is_value ident in
            let* field =
              PathName.of_path_and_name_with_convert mod_type_path name in
            let* typ_vars =
              match signature_item with
              | Types.Sig_value (_, { val_type; _ }, _) ->
                let typ_vars = Name.Map.empty in
                let* (_, _, new_typ_vars) =
                  Type.of_typ_expr true typ_vars val_type in
                return (Name.Set.elements new_typ_vars)
              | _ -> return [] in
            return (Some (ModuleIncludeItem (
              name,
              typ_vars,
              MixedPath.Access (reference, [field], false)
            )))
          | _ -> return None
        )
      | Mty_functor _ ->
        error_message
          (Error "include_functor")
          Unexpected
          "Unexpected include of functor."
      end
    | _ -> return [ModuleInclude reference]
    end in
  let of_structure_item (item : structure_item) (final_env : Env.t)
    : t list Monad.t =
    set_env item.str_env (
    set_loc (Loc.of_location item.str_loc) (
    match item.str_desc with
    | Tstr_value (_, [ {
        vb_pat = {
          pat_desc =
            Tpat_construct (
              _,
              { cstr_res = { desc = Tconstr (path, _, _); _ }; _ },
              _
            );
          _
        };
        _
      } ])
      when PathName.is_unit path ->
      top_level_evaluation_error
    | Tstr_eval _ -> top_level_evaluation_error
    | Tstr_value (is_rec, cases) ->
      push_env (
      Exp.import_let_fun Name.Map.empty true is_rec cases >>= fun def ->
      return [Value def])
    | Tstr_type (_, typs) ->
      (* Because types may be recursive, so we need the types to already be in
         the environment. This is useful for example for the detection of
         phantom types. *)
      set_env final_env (
      TypeDefinition.of_ocaml typs >>= fun def ->
      return [TypeDefinition def])
    | Tstr_exception { tyexn_constructor = { ext_id; _ }; _ } ->
      error_message (Error ("exception " ^ Ident.name ext_id)) SideEffect (
        "The definition of exceptions is not handled.\n\n" ^
        "Alternative: using sum types (\"option\", \"result\", ...) to " ^
        "represent error cases."
      )
    | Tstr_open _ -> return []
    | Tstr_module { mb_id; mb_expr; mb_attributes; _ } ->
      let* name = Name.of_ident false mb_id in
      let* has_plain_module_attribute =
        let* attributes = Attribute.of_attributes mb_attributes in
        return (Attribute.has_plain_module attributes) in
      let* module_definition =
        of_module name [] mb_expr has_plain_module_attribute in
      return [module_definition]
    | Tstr_modtype { mtd_type = None; _ } ->
      error_message
        (Error "abstract_module_type")
        NotSupported
        "Abstract module types not handled."
    | Tstr_modtype { mtd_id; mtd_type = Some { mty_desc; _ }; _ } ->
      let* name = Name.of_ident false mtd_id in
      begin
        match mty_desc with
        | Tmty_signature signature ->
          Signature.of_signature signature >>= fun signature ->
          return [Signature (name, signature)]
        | _ ->
          error_message
            (Error "unhandled_module_type")
            NotSupported
            "This kind of signature is not handled."
      end
    | Tstr_primitive { val_id; val_val = { val_type; _ }; _ } ->
      let* name = Name.of_ident true val_id in
      Type.of_typ_expr true Name.Map.empty val_type >>= fun (typ, _, free_typ_vars) ->
      return [AbstractValue (name, Name.Set.elements free_typ_vars, typ)]
    | Tstr_typext _ ->
      error_message
        (Error "type_extension")
        ExtensibleType
        "We do not handle type extensions"
    | Tstr_recmodule _ ->
      error_message
        (Error "recursive_module")
        NotSupported
        "Structure item `recmodule` not handled."
    | Tstr_class _ ->
      error_message
        (Error "class")
        NotSupported
        "Structure item `class` not handled."
    | Tstr_class_type _ ->
      error_message
        (Error "class_type")
        NotSupported
        "Structure item `class_type` not handled."
    | Tstr_include {
        incl_mod = { mod_desc = Tmod_ident (path, _); mod_type; _ };
        _
      }
    | Tstr_include {
        incl_mod = {
          mod_desc = Tmod_constraint ({ mod_desc = Tmod_ident (path, _); _ }, _, _, _);
          mod_type;
          _
        };
        _
      } ->
      let* reference = PathName.of_path_with_convert false path in
      get_include_items (Some path) reference mod_type
    | Tstr_include { incl_mod; _ } ->
      let* include_name = Exp.get_include_name incl_mod in
      let* module_definition = of_module include_name [] incl_mod false in
      let reference = PathName.of_name [] include_name in
      let* include_items =
        get_include_items None reference incl_mod.mod_type in
      return (module_definition :: include_items)
    (* We ignore attribute fields. *)
    | Tstr_attribute _ -> return [])) in
  Monad.List.fold_right
    (fun structure_item (structure, final_env) ->
      let env = structure_item.str_env in
      of_structure_item structure_item final_env >>= fun structure_item ->
      return (structure_item @ structure, env)
    )
    structure.str_items
    ([], structure.str_final_env) >>= fun (structure, _) ->
  return structure

and of_module
  (name : Name.t) (functor_parameters : (Name.t * Type.t) list)
  (module_expr : module_expr) (has_plain_module_attribute : bool)
  : t Monad.t =
  let path =
    match module_expr.mod_desc with
    | Tmod_ident (path, _)
    | Tmod_constraint ({ mod_desc = Tmod_ident (path, _); _ }, _, _, _) ->
      Some path
    | _ -> None in
  let* is_first_class =
    IsFirstClassModule.is_module_typ_first_class module_expr.mod_type path in
  let as_expression =
    match (is_first_class, has_plain_module_attribute) with
    | (Found module_type_path, false) ->
      Some (module_expr.mod_type, module_type_path)
    | _ -> None in
  of_module_expr name functor_parameters as_expression None module_expr

and of_module_expr
  (name : Name.t) (functor_parameters : (Name.t * Type.t) list)
  (as_expression : (Types.module_type * Path.t) option)
  (module_type_annotation : Typedtree.module_type option)
  (module_expr : module_expr)
  : t Monad.t =
  match module_expr.mod_desc with
  | Tmod_structure structure ->
    let* structure = of_structure structure in
    let* e =
      match as_expression with
      | Some (module_type, module_type_path) ->
        let typ_vars = Name.Map.empty in
        let* module_typ_params_arity =
          ModuleTypParams.get_module_typ_typ_params_arity module_type in
        let* values = Exp.ModuleTypValues.get typ_vars module_type in
        let mixed_path_of_value_or_typ (name : Name.t): MixedPath.t Monad.t =
          return (MixedPath.of_name name) in
        let* e =
          Exp.build_module
            module_typ_params_arity
            values
            module_type_path
            mixed_path_of_value_or_typ in
        let* module_type_annotation =
          match module_type_annotation with
          | Some module_type ->
            let* module_type = ModuleTyp.of_ocaml module_type in
            return (Some (ModuleTyp.to_typ module_type))
          | None -> return None in
        return (Some (e, module_type_annotation))
      | None -> return None in
    return (Module (name, List.rev functor_parameters, structure, e))
  | Tmod_ident (path, _) ->
    begin match as_expression  with
    | Some (module_type, _) ->
      let* module_exp =
        Exp.of_module_expr Name.Map.empty module_expr (Some module_type) in
      return (ModuleExpression (name, module_exp))
    | None ->
      let* reference = PathName.of_path_with_convert false path in
      return (ModuleSynonym (name, reference))
    end
  | Tmod_apply _ ->
      let* module_exp = Exp.of_module_expr Name.Map.empty module_expr None in
      return (ModuleExpression (name, module_exp))
  | Tmod_functor (ident, _, module_type_arg, module_expr) ->
    let* functor_parameters =
      match module_type_arg with
      | None -> return functor_parameters
      | Some module_type_arg ->
        let* x = Name.of_ident false ident in
        let* module_type_arg = ModuleTyp.of_ocaml module_type_arg in
        return ((x, ModuleTyp.to_typ module_type_arg) :: functor_parameters) in
    of_module name functor_parameters module_expr false
  | Tmod_constraint (module_expr, _, annotation, _) ->
    let module_type_annotation =
      match annotation with
      | Tmodtype_explicit module_type -> Some module_type
      | Tmodtype_implicit -> module_type_annotation in
    of_module_expr
      name functor_parameters as_expression module_type_annotation module_expr
  | Tmod_unpack _ ->
    return (Error
      "Cannot unpack first-class modules at top-level due to a universe inconsistency"
    )

(** Pretty-print a structure to Coq. *)
let rec to_coq (with_args : bool) (defs : t list) : SmartPrint.t =
  let rec to_coq_one (def : t) : SmartPrint.t =
    match def with
    | Value value -> Value.to_coq with_args value
    | AbstractValue (name, typ_vars, typ) ->
      !^ "Parameter" ^^ Name.to_coq name ^^ !^ ":" ^^
      (match typ_vars with
      | [] -> empty
      | _ :: _ ->
        !^ "forall" ^^
        nest (parens (separate space (typ_vars |> List.map Name.to_coq) ^^ !^ ":" ^^ Pp.set)) ^-^ !^ ","
      ) ^^
      Type.to_coq None None typ ^-^ !^ "."
    | TypeDefinition typ_def -> TypeDefinition.to_coq with_args typ_def
    | Module (name, functor_parameters, defs, e) ->
      let is_functor =
        match functor_parameters with
        | [] -> false
        | _ :: _ -> true in
      let final_item_name =
        if is_functor then !^ "functor" else !^ "module" in
      nest (
        !^ "Module" ^^ Name.to_coq name ^-^ !^ "." ^^
        newline ^^
        indent (
          begin if is_functor then
            nest (
              !^ "Class" ^^ !^ "FArgs" ^^ Pp.args with_args ^^ !^ ":=" ^^
              !^ "{" ^^ newline ^^
              indent (
                separate empty (functor_parameters |> List.map (
                fun (name, typ) ->
                  nest (
                    Name.to_coq name ^^ !^ ":" ^^ Type.to_coq None None typ ^-^
                    !^ ";" ^^ newline
                  )
                ))
              )
              ^^ !^ "}" ^-^ !^ "." ^^
              newline ^^ newline
            )
          else
            empty
          end ^^
          to_coq (is_functor || with_args) defs ^^
          begin match e with
          | Some (e, typ_annotation) ->
            newline ^^ newline ^^
            nest (
              !^ "Definition" ^^ final_item_name ^^
              begin if is_functor then
                !^ "`(FArgs)"
              else
                Pp.args with_args
              end ^^
              nest (
                begin match (typ_annotation, is_functor) with
                | (Some typ_annotation, true) ->
                  nest (!^ ":" ^^ Type.to_coq None None typ_annotation)
                | _ -> empty
                end ^^
                !^ ":="
              ) ^^
              Exp.to_coq false e ^-^ !^ "."
            )
          | None -> empty
          end
        ) ^^ newline ^^
        !^ "End" ^^ Name.to_coq name ^-^ !^ "." ^^
        begin match e with
        | Some _ ->
          newline ^^
          nest (
            !^ "Definition" ^^ Name.to_coq name ^^ Pp.args with_args ^^
            separate space (functor_parameters |> List.map (fun (name, _) ->
              Name.to_coq name
            )) ^^ !^ ":=" ^^
            nest (
              Name.to_coq name ^-^ !^ "." ^-^ final_item_name ^-^
              begin if is_functor then
                space ^^
                nest (
                  !^ "{|" ^^
                  separate (!^ ";" ^^ space) (functor_parameters |> List.map (
                    fun (parameter_name, _) ->
                      nest (
                        Name.to_coq name ^-^ !^ "." ^-^ Name.to_coq parameter_name ^^
                        !^ ":=" ^^ Name.to_coq parameter_name
                      )
                  )) ^^
                  !^ "|}"
                )
              else
                empty
              end ^-^
              !^ "."
            )
          )
        | None -> empty
        end
      )
    | ModuleExpression (name, e) ->
      nest (
        !^ "Definition" ^^ Name.to_coq name ^^ Pp.args with_args ^^ !^ ":=" ^^
        Exp.to_coq false e ^-^ !^ "."
      )
    | ModuleInclude reference ->
      nest (!^ "Include" ^^ PathName.to_coq reference ^-^ !^ ".")
    | ModuleIncludeItem (name, typ_vars, mixed_path) ->
      nest (
        !^ "Definition" ^^ Name.to_coq name ^^ Pp.args with_args ^^
        begin match typ_vars with
        | [] -> empty
        | _ :: _ ->
          nest (braces (
            separate space (typ_vars |> List.map (fun typ_var ->
              Name.to_coq typ_var
            )) ^^
            !^ ":" ^^ Pp.set
          ))
        end ^^
        !^ ":=" ^^
        nest (separate space (
          MixedPath.to_coq mixed_path ::
          (typ_vars |> List.map (fun typ_var ->
            nest (parens (
              Name.to_coq typ_var ^^ !^ ":=" ^^ Name.to_coq typ_var
            ))
          ))
        )) ^-^
        !^ "."
      )
    | ModuleSynonym (name, reference) ->
      nest (
        !^ "Module" ^^ Name.to_coq name ^^ !^ ":=" ^^ PathName.to_coq reference ^-^ !^ "."
      )
    | Signature (name, signature) -> Signature.to_coq_definition name signature
    | Error message -> !^ ( "(* " ^ message ^ " *)")
    | ErrorMessage (message, def) ->
      nest (
        Error.to_comment message ^^ newline ^^
        to_coq_one def
      ) in
  separate (newline ^^ newline) (defs |> List.map to_coq_one)
