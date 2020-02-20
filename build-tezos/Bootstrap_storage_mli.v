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
Require Tezos.Contract_storage.
Require Tezos.Cycle_repr.
Require Tezos.Parameters_repr.
Require Tezos.Raw_context.
Require Tezos.Script_repr.

Parameter init :
  Raw_context.t ->
  (Raw_context.t -> Script_repr.t ->
  Lwt.t
    (Error_monad.tzresult
      ((Script_repr.t * option Contract_storage.big_map_diff) * Raw_context.t)))
  -> option int -> option int -> list Parameters_repr.bootstrap_account ->
  list Parameters_repr.bootstrap_contract ->
  Lwt.t (Error_monad.tzresult Raw_context.t).

Parameter cycle_end :
  Raw_context.t -> Cycle_repr.t -> Lwt.t (Error_monad.tzresult Raw_context.t).
