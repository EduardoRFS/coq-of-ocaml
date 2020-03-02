(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Alpha_context.
Require Tezos.Script_typed_ir.

Import Alpha_context.

Import Script_typed_ir.

Parameter default_now_annot : option Script_typed_ir.var_annot.

Parameter default_amount_annot : option Script_typed_ir.var_annot.

Parameter default_balance_annot : option Script_typed_ir.var_annot.

Parameter default_steps_annot : option Script_typed_ir.var_annot.

Parameter default_source_annot : option Script_typed_ir.var_annot.

Parameter default_sender_annot : option Script_typed_ir.var_annot.

Parameter default_self_annot : option Script_typed_ir.var_annot.

Parameter default_arg_annot : option Script_typed_ir.var_annot.

Parameter default_param_annot : option Script_typed_ir.var_annot.

Parameter default_storage_annot : option Script_typed_ir.var_annot.

Parameter default_car_annot : option Script_typed_ir.field_annot.

Parameter default_cdr_annot : option Script_typed_ir.field_annot.

Parameter default_contract_annot : option Script_typed_ir.field_annot.

Parameter default_addr_annot : option Script_typed_ir.field_annot.

Parameter default_manager_annot : option Script_typed_ir.field_annot.

Parameter default_pack_annot : option Script_typed_ir.field_annot.

Parameter default_unpack_annot : option Script_typed_ir.field_annot.

Parameter default_slice_annot : option Script_typed_ir.field_annot.

Parameter default_elt_annot : option Script_typed_ir.field_annot.

Parameter default_key_annot : option Script_typed_ir.field_annot.

Parameter default_hd_annot : option Script_typed_ir.field_annot.

Parameter default_tl_annot : option Script_typed_ir.field_annot.

Parameter default_some_annot : option Script_typed_ir.field_annot.

Parameter default_left_annot : option Script_typed_ir.field_annot.

Parameter default_right_annot : option Script_typed_ir.field_annot.

Parameter default_binding_annot : option Script_typed_ir.field_annot.

Parameter unparse_type_annot : option Script_typed_ir.type_annot -> list string.

Parameter unparse_var_annot : option Script_typed_ir.var_annot -> list string.

Parameter unparse_field_annot :
  option Script_typed_ir.field_annot -> list string.

Parameter field_to_var_annot :
  option Script_typed_ir.field_annot -> option Script_typed_ir.var_annot.

Parameter type_to_var_annot :
  option Script_typed_ir.type_annot -> option Script_typed_ir.var_annot.

Parameter var_to_field_annot :
  option Script_typed_ir.var_annot -> option Script_typed_ir.field_annot.

Parameter default_annot : forall {a : Set}, option a -> option a -> option a.

Parameter gen_access_annot :
  option Script_typed_ir.var_annot ->
  option (option Script_typed_ir.field_annot) ->
  option Script_typed_ir.field_annot -> option Script_typed_ir.var_annot.

Parameter merge_type_annot :
  bool -> option Script_typed_ir.type_annot ->
  option Script_typed_ir.type_annot ->
  Error_monad.tzresult (option Script_typed_ir.type_annot).

Parameter merge_field_annot :
  bool -> option Script_typed_ir.field_annot ->
  option Script_typed_ir.field_annot ->
  Error_monad.tzresult (option Script_typed_ir.field_annot).

Parameter merge_var_annot :
  option Script_typed_ir.var_annot -> option Script_typed_ir.var_annot ->
  option Script_typed_ir.var_annot.

Parameter error_unexpected_annot : forall {a : Set},
  int -> list a -> Error_monad.tzresult unit.

Parameter fail_unexpected_annot : forall {a : Set},
  int -> list a -> Lwt.t (Error_monad.tzresult unit).

Parameter parse_type_annot :
  int -> list string -> Error_monad.tzresult (option Script_typed_ir.type_annot).

Parameter parse_field_annot :
  int -> list string ->
  Error_monad.tzresult (option Script_typed_ir.field_annot).

Parameter parse_type_field_annot :
  int -> list string ->
  Error_monad.tzresult
    (option Script_typed_ir.type_annot * option Script_typed_ir.field_annot).

Parameter parse_composed_type_annot :
  int -> list string ->
  Error_monad.tzresult
    (option Script_typed_ir.type_annot * option Script_typed_ir.field_annot *
      option Script_typed_ir.field_annot).

Parameter extract_field_annot :
  Alpha_context.Script.node ->
  Error_monad.tzresult
    (Alpha_context.Script.node * option Script_typed_ir.field_annot).

Parameter check_correct_field :
  option Script_typed_ir.field_annot -> option Script_typed_ir.field_annot ->
  Error_monad.tzresult unit.

Parameter parse_var_annot :
  int -> option (option Script_typed_ir.var_annot) -> list string ->
  Error_monad.tzresult (option Script_typed_ir.var_annot).

Parameter parse_constr_annot :
  int -> option (option Script_typed_ir.field_annot) ->
  option (option Script_typed_ir.field_annot) -> list string ->
  Error_monad.tzresult
    (option Script_typed_ir.var_annot * option Script_typed_ir.type_annot *
      option Script_typed_ir.field_annot * option Script_typed_ir.field_annot).

Parameter parse_two_var_annot :
  int -> list string ->
  Error_monad.tzresult
    (option Script_typed_ir.var_annot * option Script_typed_ir.var_annot).

Parameter parse_destr_annot :
  int -> list string -> option Script_typed_ir.field_annot ->
  option Script_typed_ir.field_annot -> option Script_typed_ir.var_annot ->
  option Script_typed_ir.var_annot ->
  Error_monad.tzresult
    (option Script_typed_ir.var_annot * option Script_typed_ir.field_annot).

Parameter parse_entrypoint_annot :
  int -> option (option Script_typed_ir.var_annot) -> list string ->
  Error_monad.tzresult
    (option Script_typed_ir.var_annot * option Script_typed_ir.field_annot).

Parameter parse_var_type_annot :
  int -> list string ->
  Error_monad.tzresult
    (option Script_typed_ir.var_annot * option Script_typed_ir.type_annot).
