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

Import Alpha_context.

Parameter may_start_new_voting_period :
  Alpha_context.context -> Lwt.t (Error_monad.tzresult Alpha_context.context).

(* extensible_type_definition `error` *)

Parameter record_proposals :
  Alpha_context.context -> Alpha_context.public_key_hash ->
  list (|Protocol_hash|).(S.HASH.t) ->
  Lwt.t (Error_monad.tzresult Alpha_context.context).

(* extensible_type_definition `error` *)

Parameter record_ballot :
  Alpha_context.context -> Alpha_context.public_key_hash ->
  (|Protocol_hash|).(S.HASH.t) -> Alpha_context.Vote.ballot ->
  Lwt.t (Error_monad.tzresult Alpha_context.context).
