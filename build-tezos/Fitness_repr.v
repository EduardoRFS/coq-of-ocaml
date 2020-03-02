(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Constants_repr.

(* ❌ Structure item `typext` not handled. *)
(* type_extension *)

(* ❌ Top-level evaluations are ignored *)
(* top_level_evaluation *)

Definition int64_to_bytes (i : int64) : MBytes.t :=
  let __b_value := MBytes.create 8 in
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  __b_value.

Definition int64_of_bytes (__b_value : MBytes.t) : Error_monad.tzresult int64 :=
  if (|Compare.Int|).(Compare.S.op_ltgt) (MBytes.length __b_value) 8 then
    Error_monad.__error_value extensible_type_value
  else
    Error_monad.ok (MBytes.get_int64 __b_value 0).

Definition from_int64 (fitness : int64) : list MBytes.t :=
  [ MBytes.of_string Constants_repr.version_number; int64_to_bytes fitness ].

Definition to_int64 (function_parameter : list MBytes.t)
  : Error_monad.tzresult int64 :=
  match
    (function_parameter,
      match function_parameter with
      | cons version (cons fitness []) =>
        (|Compare.String|).(Compare.S.op_eq) (MBytes.to_string version)
          Constants_repr.version_number
      | _ => false
      end,
      match function_parameter with
      | cons version (cons _fitness []) =>
        (|Compare.String|).(Compare.S.op_eq) (MBytes.to_string version)
          Constants_repr.version_number_004
      | _ => false
      end) with
  | (cons version (cons fitness []), true, _) => int64_of_bytes fitness
  | (cons version (cons _fitness []), _, true) =>
    Error_monad.ok
      (* ❌ Constant of type int64 is converted to int *)
      0
  | ([], _, _) =>
    Error_monad.ok
      (* ❌ Constant of type int64 is converted to int *)
      0
  | (_, _, _) => Error_monad.__error_value extensible_type_value
  end.
