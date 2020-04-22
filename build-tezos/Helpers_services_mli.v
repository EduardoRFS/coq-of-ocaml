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
Require Tezos.Apply_results.
Require Tezos.Michelson_v1_primitives.
Require Tezos.Nonce_hash.
Require Tezos.Script_interpreter.
Require Tezos.Script_tc_errors.

Import Alpha_context.

(* extensible_type_definition `error` *)

Parameter current_level : forall {a : Set},
  RPC_context.simple a -> option int32 -> a ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Level.t).

Parameter levels_in_current_cycle : forall {a : Set},
  RPC_context.simple a -> option int32 -> a ->
  Lwt.t
    (Error_monad.shell_tzresult
      (Alpha_context.Raw_level.t * Alpha_context.Raw_level.t)).

Module Scripts.
  Parameter run_code : forall {a : Set},
    RPC_context.simple a -> a -> Alpha_context.Script.expr ->
    Alpha_context.Script.expr * Alpha_context.Script.expr * Alpha_context.Tez.t
      * (|Chain_id|).(S.HASH.t) * option Alpha_context.Contract.t *
      option Alpha_context.Contract.t * option Z.t * string ->
    Lwt.t
      (Error_monad.shell_tzresult
        (Alpha_context.Script.expr *
          list Alpha_context.packed_internal_operation *
          option Alpha_context.Contract.big_map_diff)).
  
  Parameter trace_code : forall {a : Set},
    RPC_context.simple a -> a -> Alpha_context.Script.expr ->
    Alpha_context.Script.expr * Alpha_context.Script.expr * Alpha_context.Tez.t
      * (|Chain_id|).(S.HASH.t) * option Alpha_context.Contract.t *
      option Alpha_context.Contract.t * option Z.t * string ->
    Lwt.t
      (Error_monad.shell_tzresult
        (Alpha_context.Script.expr *
          list Alpha_context.packed_internal_operation *
          Script_interpreter.execution_trace *
          option Alpha_context.Contract.big_map_diff)).
  
  Parameter typecheck_code : forall {a : Set},
    RPC_context.simple a -> a -> Alpha_context.Script.expr * option Z.t ->
    Lwt.t
      (Error_monad.shell_tzresult
        (Script_tc_errors.type_map * Alpha_context.Gas.t)).
  
  Parameter typecheck_data : forall {a : Set},
    RPC_context.simple a -> a ->
    Alpha_context.Script.expr * Alpha_context.Script.expr * option Z.t ->
    Lwt.t (Error_monad.shell_tzresult Alpha_context.Gas.t).
  
  Parameter pack_data : forall {a : Set},
    RPC_context.simple a -> a ->
    Alpha_context.Script.expr * Alpha_context.Script.expr * option Z.t ->
    Lwt.t (Error_monad.shell_tzresult (MBytes.t * Alpha_context.Gas.t)).
  
  Parameter run_operation : forall {a : Set},
    RPC_context.simple a -> a ->
    Alpha_context.packed_operation * (|Chain_id|).(S.HASH.t) ->
    Lwt.t
      (Error_monad.shell_tzresult
        (Alpha_context.packed_protocol_data *
          Apply_results.packed_operation_metadata)).
  
  Parameter entrypoint_type : forall {a : Set},
    RPC_context.simple a -> a -> Alpha_context.Script.expr * string ->
    Lwt.t (Error_monad.shell_tzresult Alpha_context.Script.expr).
  
  Parameter list_entrypoints : forall {a : Set},
    RPC_context.simple a -> a -> Alpha_context.Script.expr ->
    Lwt.t
      (Error_monad.shell_tzresult
        (list (list Michelson_v1_primitives.prim) *
          list (string * Alpha_context.Script.expr))).
End Scripts.

Module Forge.
  Module Manager.
    Parameter operations : forall {a : Set},
      RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
      Alpha_context.public_key_hash -> option Alpha_context.public_key ->
      Alpha_context.counter -> Alpha_context.Tez.t -> Z.t -> Z.t ->
      list Alpha_context.packed_manager_operation ->
      Lwt.t (Error_monad.shell_tzresult MBytes.t).
    
    Parameter reveal : forall {a : Set},
      RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
      Alpha_context.public_key_hash -> Alpha_context.public_key ->
      Alpha_context.counter -> Alpha_context.Tez.t -> unit ->
      Lwt.t (Error_monad.shell_tzresult MBytes.t).
    
    Parameter transaction : forall {a : Set},
      RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
      Alpha_context.public_key_hash -> option Alpha_context.public_key ->
      Alpha_context.counter -> Alpha_context.Tez.t ->
      Alpha_context.Contract.t -> option string ->
      option Alpha_context.Script.expr -> Z.t -> Z.t -> Alpha_context.Tez.t ->
      unit -> Lwt.t (Error_monad.shell_tzresult MBytes.t).
    
    Parameter origination : forall {a : Set},
      RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
      Alpha_context.public_key_hash -> option Alpha_context.public_key ->
      Alpha_context.counter -> Alpha_context.Tez.t ->
      option Alpha_context.public_key_hash -> Alpha_context.Script.t -> Z.t ->
      Z.t -> Alpha_context.Tez.t -> unit ->
      Lwt.t (Error_monad.shell_tzresult MBytes.t).
    
    Parameter delegation : forall {a : Set},
      RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
      Alpha_context.public_key_hash -> option Alpha_context.public_key ->
      Alpha_context.counter -> Alpha_context.Tez.t ->
      option Alpha_context.public_key_hash ->
      Lwt.t (Error_monad.shell_tzresult MBytes.t).
  End Manager.
  
  Parameter endorsement : forall {a : Set},
    RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
    Alpha_context.Raw_level.t -> unit ->
    Lwt.t (Error_monad.shell_tzresult MBytes.t).
  
  Parameter proposals : forall {a : Set},
    RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
    Alpha_context.public_key_hash -> Alpha_context.Voting_period.t ->
    list (|Protocol_hash|).(S.HASH.t) -> unit ->
    Lwt.t (Error_monad.shell_tzresult MBytes.t).
  
  Parameter ballot : forall {a : Set},
    RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
    Alpha_context.public_key_hash -> Alpha_context.Voting_period.t ->
    (|Protocol_hash|).(S.HASH.t) -> Alpha_context.Vote.ballot -> unit ->
    Lwt.t (Error_monad.shell_tzresult MBytes.t).
  
  Parameter seed_nonce_revelation : forall {a : Set},
    RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
    Alpha_context.Raw_level.t -> Alpha_context.Nonce.t -> unit ->
    Lwt.t (Error_monad.shell_tzresult MBytes.t).
  
  Parameter double_baking_evidence : forall {a : Set},
    RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
    Alpha_context.Block_header.block_header ->
    Alpha_context.Block_header.block_header -> unit ->
    Lwt.t (Error_monad.shell_tzresult MBytes.t).
  
  Parameter double_endorsement_evidence : forall {a : Set},
    RPC_context.simple a -> a -> (|Block_hash|).(S.HASH.t) ->
    Alpha_context.operation -> Alpha_context.operation -> unit ->
    Lwt.t (Error_monad.shell_tzresult MBytes.t).
  
  Parameter protocol_data : forall {a : Set},
    RPC_context.simple a -> a -> int -> option Nonce_hash.t ->
    option MBytes.t -> unit -> Lwt.t (Error_monad.shell_tzresult MBytes.t).
End Forge.

Module Parse.
  Parameter operations : forall {a : Set},
    RPC_context.simple a -> a -> option bool ->
    list Alpha_context.Operation.raw ->
    Lwt.t (Error_monad.shell_tzresult (list Alpha_context.Operation.packed)).
  
  Parameter block : forall {a : Set},
    RPC_context.simple a -> a -> Alpha_context.Block_header.shell_header ->
    MBytes.t ->
    Lwt.t (Error_monad.shell_tzresult Alpha_context.Block_header.protocol_data).
End Parse.

Parameter register : unit -> unit.