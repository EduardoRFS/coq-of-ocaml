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
Require Tezos.Alpha_context.
Require Tezos.Misc.

Import Alpha_context.

Import Misc.

(* extensible_type_definition `error` *)

(* extensible_type_definition `error` *)

(* extensible_type_definition `error` *)

(* extensible_type_definition `error` *)

(* extensible_type_definition `error` *)

(* extensible_type_definition `error` *)

Parameter minimal_time :
  Alpha_context.context -> Z -> Time.t -> Lwt.t (Error_monad.tzresult Time.t).

Parameter check_baking_rights :
  Alpha_context.context -> Alpha_context.Block_header.contents -> Time.t ->
  Lwt.t
    (Error_monad.tzresult (Alpha_context.public_key * Alpha_context.Period.t)).

Parameter endorsement_rights :
  Alpha_context.context -> Alpha_context.Level.t ->
  Lwt.t
    (Error_monad.tzresult
      ((|Signature.Public_key_hash|).(S.SPublic_key_hash.Map).(S.INDEXES_Map.t)
        (Alpha_context.public_key * list Z * bool))).

Parameter check_endorsement_rights :
  Alpha_context.context -> (|Chain_id|).(S.HASH.t) ->
  Alpha_context.Operation.t Alpha_context.Kind.endorsement ->
  Lwt.t (Error_monad.tzresult (Alpha_context.public_key_hash * list Z * bool)).

Parameter baking_reward :
  Alpha_context.context -> Z -> Z ->
  Lwt.t (Error_monad.tzresult Alpha_context.Tez.t).

Parameter endorsing_reward :
  Alpha_context.context -> Z -> Z ->
  Lwt.t (Error_monad.tzresult Alpha_context.Tez.t).

Parameter baking_priorities :
  Alpha_context.context -> Alpha_context.Level.t ->
  Misc.lazy_list Alpha_context.public_key.

Parameter first_baking_priorities :
  Alpha_context.context -> option Z -> Alpha_context.public_key_hash ->
  Alpha_context.Level.t -> Lwt.t (Error_monad.tzresult (list Z)).

Parameter check_signature :
  Alpha_context.Block_header.t -> (|Chain_id|).(S.HASH.t) ->
  Alpha_context.public_key -> Lwt.t (Error_monad.tzresult unit).

Parameter check_header_proof_of_work_stamp :
  Alpha_context.Block_header.shell_header ->
  Alpha_context.Block_header.contents -> int64 -> bool.

Parameter check_proof_of_work_stamp :
  Alpha_context.context -> Alpha_context.Block_header.t ->
  Lwt.t (Error_monad.tzresult unit).

Parameter check_fitness_gap :
  Alpha_context.context -> Alpha_context.Block_header.t ->
  Lwt.t (Error_monad.tzresult unit).

Parameter dawn_of_a_new_cycle :
  Alpha_context.context ->
  Lwt.t (Error_monad.tzresult (option Alpha_context.Cycle.t)).

Parameter earlier_predecessor_timestamp :
  Alpha_context.context -> Alpha_context.Level.t ->
  Lwt.t (Error_monad.tzresult Alpha_context.Timestamp.t).

Parameter minimum_allowed_endorsements :
  Alpha_context.context -> Alpha_context.Period.t -> Z.

Parameter minimal_valid_time :
  Alpha_context.context -> Z -> Z -> Lwt.t (Error_monad.tzresult Time.t).
