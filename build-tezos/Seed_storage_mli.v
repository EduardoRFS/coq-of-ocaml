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
Require Tezos.Cycle_repr.
Require Tezos.Nonce_storage.
Require Tezos.Raw_context.
Require Tezos.Seed_repr.

(* extensible_type_definition `error` *)

Parameter init : Raw_context.t -> Lwt.t (Error_monad.tzresult Raw_context.t).

Parameter for_cycle :
  Raw_context.t -> Cycle_repr.t -> Lwt.t (Error_monad.tzresult Seed_repr.seed).

Parameter cycle_end :
  Raw_context.t -> Cycle_repr.t ->
  Lwt.t (Error_monad.tzresult (Raw_context.t * list Nonce_storage.unrevealed)).
