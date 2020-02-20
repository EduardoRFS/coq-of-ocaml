(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Gas_limit_repr.
Require Tezos.Michelson_v1_primitives.

Definition location : Set := Micheline.canonical_location.

Definition location_encoding
  : Data_encoding.encoding Micheline.canonical_location :=
  Micheline.canonical_location_encoding.

Definition annot : Set := Micheline.annot.

Definition expr : Set := Micheline.canonical Michelson_v1_primitives.prim.

Definition lazy_expr : Set := Data_encoding.lazy_t expr.

Definition node : Set := Micheline.node location Michelson_v1_primitives.prim.

Definition expr_encoding
  : Data_encoding.encoding (Micheline.canonical Michelson_v1_primitives.prim) :=
  Micheline.canonical_encoding_v1 "michelson_v1"
    Michelson_v1_primitives.prim_encoding.

(* ❌ Structure item `typext` not handled. *)
(* type_extension *)

(* ❌ Top-level evaluations are ignored *)
(* top_level_evaluation *)

Definition lazy_expr_encoding
  : Data_encoding.encoding
    (Data_encoding.lazy_t (Micheline.canonical Michelson_v1_primitives.prim)) :=
  Data_encoding.lazy_encoding expr_encoding.

Definition __lazy_expr_value
  (expr : Micheline.canonical Michelson_v1_primitives.prim)
  : Data_encoding.lazy_t (Micheline.canonical Michelson_v1_primitives.prim) :=
  Data_encoding.make_lazy expr_encoding expr.

Module t.
  Record record : Set := Build {
    code : lazy_expr;
    storage : lazy_expr }.
  Definition with_code code (r : record) :=
    Build code r.(storage).
  Definition with_storage storage (r : record) :=
    Build r.(code) storage.
End t.
Definition t := t.record.

Definition encoding : Data_encoding.encoding t :=
  (let arg := Data_encoding.def "scripted.contracts" in
  fun eta => arg None None eta)
    (Data_encoding.conv
      (fun function_parameter =>
        let '{| t.code := code; t.storage := storage |} := function_parameter in
        (code, storage))
      (fun function_parameter =>
        let '(code, storage) := function_parameter in
        {| t.code := code; t.storage := storage |}) None
      (Data_encoding.obj2
        (Data_encoding.req None None "code" lazy_expr_encoding)
        (Data_encoding.req None None "storage" lazy_expr_encoding))).

Definition int_node_size_of_numbits (n : int) : int * int :=
  (1, (Pervasives.op_plus 1 (Pervasives.op_div (Pervasives.op_plus n 63) 64))).

Definition int_node_size (n : Z.t) : int * int :=
  int_node_size_of_numbits (Z.numbits n).

Definition string_node_size_of_length (s : int) : int * int :=
  (1, (Pervasives.op_plus 1 (Pervasives.op_div (Pervasives.op_plus s 7) 8))).

Definition string_node_size (s : string) : int * int :=
  string_node_size_of_length (String.length s).

Definition bytes_node_size_of_length (s : int) : int * int :=
  (2,
    (Pervasives.op_plus
      (Pervasives.op_plus 1 (Pervasives.op_div (Pervasives.op_plus s 7) 8)) 12)).

Definition bytes_node_size (s : MBytes.t) : int * int :=
  bytes_node_size_of_length (MBytes.length s).

Definition prim_node_size_nonrec_of_lengths
  (n_args : int) (annots : list string) : int * int :=
  let annots_length :=
    List.fold_left
      (fun acc => fun s => Pervasives.op_plus acc (String.length s)) 0 annots in
  if (|Compare.Int|).(Compare.S.op_eq) annots_length 0 then
    ((Pervasives.op_plus 1 n_args),
      (Pervasives.op_plus 2 (Pervasives.op_star 2 n_args)))
  else
    ((Pervasives.op_plus 2 n_args),
      (Pervasives.op_plus (Pervasives.op_plus 4 (Pervasives.op_star 2 n_args))
        (Pervasives.op_div (Pervasives.op_plus annots_length 7) 8))).

Definition prim_node_size_nonrec {A : Set}
  (args : list A) (annots : list string) : int * int :=
  let n_args := List.length args in
  prim_node_size_nonrec_of_lengths n_args annots.

Definition seq_node_size_nonrec_of_length (n_args : int) : int * int :=
  ((Pervasives.op_plus 1 n_args),
    (Pervasives.op_plus 2 (Pervasives.op_star 2 n_args))).

Definition seq_node_size_nonrec {A : Set} (args : list A) : int * int :=
  let n_args := List.length args in
  seq_node_size_nonrec_of_length n_args.

Fixpoint node_size {A B : Set} (node : Micheline.node A B) {struct node}
  : int * int :=
  match node with
  | Micheline.Int _ n => int_node_size n
  | Micheline.String _ s => string_node_size s
  | Micheline.Bytes _ s => bytes_node_size s
  | Micheline.Prim _ _ args annot =>
    List.fold_left
      (fun function_parameter =>
        let '(blocks, words) := function_parameter in
        fun node =>
          let '(nblocks, nwords) := node_size node in
          ((Pervasives.op_plus blocks nblocks),
            (Pervasives.op_plus words nwords)))
      (prim_node_size_nonrec args annot) args
  | Micheline.Seq _ args =>
    List.fold_left
      (fun function_parameter =>
        let '(blocks, words) := function_parameter in
        fun node =>
          let '(nblocks, nwords) := node_size node in
          ((Pervasives.op_plus blocks nblocks),
            (Pervasives.op_plus words nwords))) (seq_node_size_nonrec args) args
  end.

Definition expr_size {A : Set} (expr : Micheline.canonical A) : int * int :=
  node_size (Micheline.root expr).

Definition traversal_cost {A B : Set} (node : Micheline.node A B)
  : Gas_limit_repr.cost :=
  let '(blocks, _words) := node_size node in
  Gas_limit_repr.step_cost blocks.

Definition cost_of_size (function_parameter : int * int)
  : Gas_limit_repr.cost :=
  let '(blocks, words) := function_parameter in
  Gas_limit_repr.op_plusat
    (Gas_limit_repr.op_plusat
      (Gas_limit_repr.op_starat
        ((|Compare.Int|).(Compare.S.max) 0 (Pervasives.op_minus blocks 1))
        (Gas_limit_repr.alloc_cost 0)) (Gas_limit_repr.alloc_cost words))
    (Gas_limit_repr.step_cost blocks).

Definition node_cost {A B : Set} (node : Micheline.node A B)
  : Gas_limit_repr.cost := cost_of_size (node_size node).

Definition int_node_cost (n : Z.t) : Gas_limit_repr.cost :=
  cost_of_size (int_node_size n).

Definition int_node_cost_of_numbits (n : int) : Gas_limit_repr.cost :=
  cost_of_size (int_node_size_of_numbits n).

Definition string_node_cost (s : string) : Gas_limit_repr.cost :=
  cost_of_size (string_node_size s).

Definition string_node_cost_of_length (s : int) : Gas_limit_repr.cost :=
  cost_of_size (string_node_size_of_length s).

Definition bytes_node_cost (s : MBytes.t) : Gas_limit_repr.cost :=
  cost_of_size (bytes_node_size s).

Definition bytes_node_cost_of_length (s : int) : Gas_limit_repr.cost :=
  cost_of_size (bytes_node_size_of_length s).

Definition prim_node_cost_nonrec {A : Set} (args : list A) (annot : list string)
  : Gas_limit_repr.cost := cost_of_size (prim_node_size_nonrec args annot).

Definition prim_node_cost_nonrec_of_length (n_args : int) (annot : list string)
  : Gas_limit_repr.cost :=
  cost_of_size (prim_node_size_nonrec_of_lengths n_args annot).

Definition seq_node_cost_nonrec {A : Set} (args : list A)
  : Gas_limit_repr.cost := cost_of_size (seq_node_size_nonrec args).

Definition seq_node_cost_nonrec_of_length (n_args : int)
  : Gas_limit_repr.cost := cost_of_size (seq_node_size_nonrec_of_length n_args).

Definition deserialized_cost {A : Set} (expr : Micheline.canonical A)
  : Gas_limit_repr.cost := cost_of_size (expr_size expr).

Definition serialized_cost (__bytes_value : MBytes.t) : Gas_limit_repr.cost :=
  Gas_limit_repr.alloc_mbytes_cost (MBytes.length __bytes_value).

Definition force_decode {A : Set}
  (lexpr : Data_encoding.lazy_t (Micheline.canonical A))
  : Error_monad.tzresult (Micheline.canonical A * Gas_limit_repr.cost) :=
  let account_deserialization_cost :=
    Data_encoding.apply_lazy
      (fun function_parameter =>
        let '_ := function_parameter in
        false)
      (fun function_parameter =>
        let '_ := function_parameter in
        true)
      (fun function_parameter =>
        let '_ := function_parameter in
        fun function_parameter =>
          let '_ := function_parameter in
          false) lexpr in
  match Data_encoding.force_decode lexpr with
  | Some v =>
    if account_deserialization_cost then
      Error_monad.ok (v, (deserialized_cost v))
    else
      Error_monad.ok (v, Gas_limit_repr.free)
  | None => Error_monad.__error_value extensible_type_value
  end.

Definition force_bytes {A : Set}
  (expr : Data_encoding.lazy_t (Micheline.canonical A))
  : Error_monad.tzresult (MBytes.t * Gas_limit_repr.cost) :=
  let account_serialization_cost :=
    Data_encoding.apply_lazy (fun v => Some v)
      (fun function_parameter =>
        let '_ := function_parameter in
        None)
      (fun function_parameter =>
        let '_ := function_parameter in
        fun function_parameter =>
          let '_ := function_parameter in
          None) expr in
  let '__bytes_value := Data_encoding.force_bytes expr in
  match account_serialization_cost with
  | Some v =>
    Error_monad.ok
      (__bytes_value,
        (Gas_limit_repr.op_plusat (traversal_cost (Micheline.root v))
          (serialized_cost __bytes_value)))
  | None => Error_monad.ok (__bytes_value, Gas_limit_repr.free)
  end.

Definition minimal_deserialize_cost {A : Set} (lexpr : Data_encoding.lazy_t A)
  : Gas_limit_repr.cost :=
  Data_encoding.apply_lazy
    (fun function_parameter =>
      let '_ := function_parameter in
      Gas_limit_repr.free) (fun __b_value => serialized_cost __b_value)
    (fun c_free =>
      fun function_parameter =>
        let '_ := function_parameter in
        c_free) lexpr.

Definition __unit_value : Micheline.canonical Michelson_v1_primitives.prim :=
  Micheline.strip_locations
    (Micheline.Prim 0 Michelson_v1_primitives.D_Unit nil nil).

Definition unit_parameter
  : Data_encoding.lazy_t (Micheline.canonical Michelson_v1_primitives.prim) :=
  __lazy_expr_value __unit_value.

Definition is_unit_parameter
  : Data_encoding.lazy_t (Micheline.canonical Michelson_v1_primitives.prim) ->
  bool :=
  let unit_bytes := Data_encoding.force_bytes unit_parameter in
  Data_encoding.apply_lazy
    (fun v =>
      match Micheline.root v with
      | Micheline.Prim _ Michelson_v1_primitives.D_Unit [] [] => true
      | _ => false
      end) (fun __b_value => MBytes.op_eq __b_value unit_bytes)
    (fun res =>
      fun function_parameter =>
        let '_ := function_parameter in
        res).

Fixpoint strip_annotations {A B : Set} (node : Micheline.node A B) {struct node}
  : Micheline.node A B :=
  match node with
  | (Micheline.Int _ _ | Micheline.String _ _ | Micheline.Bytes _ _) as leaf =>
    leaf
  | Micheline.Prim loc name args _ =>
    Micheline.Prim loc name (List.map strip_annotations args) nil
  | Micheline.Seq loc args =>
    Micheline.Seq loc (List.map strip_annotations args)
  end.
