(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Alpha_context.
Require Tezos.Services_registration.

Import Alpha_context.

Module S.
  Definition path : RPC_path.path Updater.rpc_context Updater.rpc_context :=
    RPC_path.op_div RPC_path.open_root "votes".
  
  Definition ballots
    : RPC_service.service (* `GET *) unit Updater.rpc_context
      Updater.rpc_context unit unit Alpha_context.Vote.ballots :=
    RPC_service.get_service
      (Some "Sum of ballots casted so far during a voting period.")
      RPC_query.empty Alpha_context.Vote.ballots_encoding
      (RPC_path.op_div path "ballots").
  
  Definition ballot_list
    : RPC_service.service (* `GET *) unit Updater.rpc_context
      Updater.rpc_context unit unit
      (list
        ((|Signature.Public_key_hash|).(S.SPublic_key_hash.t) *
          Alpha_context.Vote.ballot)) :=
    RPC_service.get_service
      (Some "Ballots casted so far during a voting period.") RPC_query.empty
      (Data_encoding.__list_value None
        (Data_encoding.obj2
          (Data_encoding.req None None "pkh"
            (|Signature.Public_key_hash|).(S.SPublic_key_hash.encoding))
          (Data_encoding.req None None "ballot"
            Alpha_context.Vote.ballot_encoding)))
      (RPC_path.op_div path "ballot_list").
  
  Definition current_period_kind
    : RPC_service.service (* `GET *) unit Updater.rpc_context
      Updater.rpc_context unit unit Alpha_context.Voting_period.kind :=
    RPC_service.get_service (Some "Current period kind.") RPC_query.empty
      Alpha_context.Voting_period.kind_encoding
      (RPC_path.op_div path "current_period_kind").
  
  Definition current_quorum
    : RPC_service.service (* `GET *) unit Updater.rpc_context
      Updater.rpc_context unit unit int32 :=
    RPC_service.get_service (Some "Current expected quorum.") RPC_query.empty
      Data_encoding.__int32_value (RPC_path.op_div path "current_quorum").
  
  Definition listings
    : RPC_service.service (* `GET *) unit Updater.rpc_context
      Updater.rpc_context unit unit
      (list ((|Signature.Public_key_hash|).(S.SPublic_key_hash.t) * int32)) :=
    RPC_service.get_service
      (Some "List of delegates with their voting weight, in number of rolls.")
      RPC_query.empty Alpha_context.Vote.listings_encoding
      (RPC_path.op_div path "listings").
  
  Definition proposals
    : RPC_service.service (* `GET *) unit Updater.rpc_context
      Updater.rpc_context unit unit
      ((|Protocol_hash|).(S.HASH.Map).(S.INDEXES_Map.t) int32) :=
    RPC_service.get_service
      (Some "List of proposals with number of supporters.") RPC_query.empty
      ((|Protocol_hash|).(S.HASH.Map).(S.INDEXES_Map.encoding)
        Data_encoding.__int32_value) (RPC_path.op_div path "proposals").
  
  Definition current_proposal
    : RPC_service.service (* `GET *) unit Updater.rpc_context
      Updater.rpc_context unit unit (option (|Protocol_hash|).(S.HASH.t)) :=
    RPC_service.get_service (Some "Current proposal under evaluation.")
      RPC_query.empty
      (Data_encoding.__option_value (|Protocol_hash|).(S.HASH.encoding))
      (RPC_path.op_div path "current_proposal").
End S.

Definition register (function_parameter : unit) : unit :=
  let '_ := function_parameter in
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  Services_registration.register0 S.current_proposal
    (fun ctxt =>
      fun function_parameter =>
        let '_ := function_parameter in
        fun function_parameter =>
          let '_ := function_parameter in
          Error_monad.op_gtgteq (Alpha_context.Vote.get_current_proposal ctxt)
            (fun function_parameter =>
              match function_parameter with
              | Pervasives.Ok p => Error_monad.return_some p
              | (Pervasives.Error _) as e => Lwt.__return e
              end)).

Definition ballots {D E G I K L a b c i o q : Set}
  (ctxt :
    (((RPC_service.t
      ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
        (* `POST *) unit + (* `PUT *) unit) RPC_context.t RPC_context.t q i o ->
    D -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
          (* `POST *) unit + (* `PUT *) unit) RPC_context.t (RPC_context.t * a)
        q i o -> D -> a -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (G * a * q * i * o)) *
        (((RPC_service.t
          ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
            (* `POST *) unit + (* `PUT *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> D -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (I * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
              (* `POST *) unit + (* `PUT *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> D -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (K * a * b * c * q * i * o)) * L)))) * L * D) (block : D)
  : Lwt.t (Error_monad.shell_tzresult Alpha_context.Vote.ballots) :=
  RPC_context.make_call0 S.ballots ctxt block tt tt.

Definition ballot_list {D E G I K L a b c i o q : Set}
  (ctxt :
    (((RPC_service.t
      ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
        (* `POST *) unit + (* `PUT *) unit) RPC_context.t RPC_context.t q i o ->
    D -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
          (* `POST *) unit + (* `PUT *) unit) RPC_context.t (RPC_context.t * a)
        q i o -> D -> a -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (G * a * q * i * o)) *
        (((RPC_service.t
          ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
            (* `POST *) unit + (* `PUT *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> D -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (I * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
              (* `POST *) unit + (* `PUT *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> D -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (K * a * b * c * q * i * o)) * L)))) * L * D) (block : D)
  : Lwt.t
    (Error_monad.shell_tzresult
      (list
        ((|Signature.Public_key_hash|).(S.SPublic_key_hash.t) *
          Alpha_context.Vote.ballot))) :=
  RPC_context.make_call0 S.ballot_list ctxt block tt tt.

Definition current_period_kind {D E G I K L a b c i o q : Set}
  (ctxt :
    (((RPC_service.t
      ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
        (* `POST *) unit + (* `PUT *) unit) RPC_context.t RPC_context.t q i o ->
    D -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
          (* `POST *) unit + (* `PUT *) unit) RPC_context.t (RPC_context.t * a)
        q i o -> D -> a -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (G * a * q * i * o)) *
        (((RPC_service.t
          ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
            (* `POST *) unit + (* `PUT *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> D -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (I * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
              (* `POST *) unit + (* `PUT *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> D -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (K * a * b * c * q * i * o)) * L)))) * L * D) (block : D)
  : Lwt.t (Error_monad.shell_tzresult Alpha_context.Voting_period.kind) :=
  RPC_context.make_call0 S.current_period_kind ctxt block tt tt.

Definition current_quorum {D E G I K L a b c i o q : Set}
  (ctxt :
    (((RPC_service.t
      ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
        (* `POST *) unit + (* `PUT *) unit) RPC_context.t RPC_context.t q i o ->
    D -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
          (* `POST *) unit + (* `PUT *) unit) RPC_context.t (RPC_context.t * a)
        q i o -> D -> a -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (G * a * q * i * o)) *
        (((RPC_service.t
          ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
            (* `POST *) unit + (* `PUT *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> D -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (I * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
              (* `POST *) unit + (* `PUT *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> D -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (K * a * b * c * q * i * o)) * L)))) * L * D) (block : D)
  : Lwt.t (Error_monad.shell_tzresult int32) :=
  RPC_context.make_call0 S.current_quorum ctxt block tt tt.

Definition listings {D E G I K L a b c i o q : Set}
  (ctxt :
    (((RPC_service.t
      ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
        (* `POST *) unit + (* `PUT *) unit) RPC_context.t RPC_context.t q i o ->
    D -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
          (* `POST *) unit + (* `PUT *) unit) RPC_context.t (RPC_context.t * a)
        q i o -> D -> a -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (G * a * q * i * o)) *
        (((RPC_service.t
          ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
            (* `POST *) unit + (* `PUT *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> D -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (I * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
              (* `POST *) unit + (* `PUT *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> D -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (K * a * b * c * q * i * o)) * L)))) * L * D) (block : D)
  : Lwt.t
    (Error_monad.shell_tzresult
      (list ((|Signature.Public_key_hash|).(S.SPublic_key_hash.t) * int32))) :=
  RPC_context.make_call0 S.listings ctxt block tt tt.

Definition proposals {D E G I K L a b c i o q : Set}
  (ctxt :
    (((RPC_service.t
      ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
        (* `POST *) unit + (* `PUT *) unit) RPC_context.t RPC_context.t q i o ->
    D -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
          (* `POST *) unit + (* `PUT *) unit) RPC_context.t (RPC_context.t * a)
        q i o -> D -> a -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (G * a * q * i * o)) *
        (((RPC_service.t
          ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
            (* `POST *) unit + (* `PUT *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> D -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (I * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
              (* `POST *) unit + (* `PUT *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> D -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (K * a * b * c * q * i * o)) * L)))) * L * D) (block : D)
  : Lwt.t
    (Error_monad.shell_tzresult
      ((|Protocol_hash|).(S.HASH.Map).(S.INDEXES_Map.t) int32)) :=
  RPC_context.make_call0 S.proposals ctxt block tt tt.

Definition current_proposal {D E G I K L a b c i o q : Set}
  (ctxt :
    (((RPC_service.t
      ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
        (* `POST *) unit + (* `PUT *) unit) RPC_context.t RPC_context.t q i o ->
    D -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
          (* `POST *) unit + (* `PUT *) unit) RPC_context.t (RPC_context.t * a)
        q i o -> D -> a -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (G * a * q * i * o)) *
        (((RPC_service.t
          ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
            (* `POST *) unit + (* `PUT *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> D -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (I * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `DELETE *) unit + (* `GET *) unit + (* `PATCH *) unit +
              (* `POST *) unit + (* `PUT *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> D -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (K * a * b * c * q * i * o)) * L)))) * L * D) (block : D)
  : Lwt.t (Error_monad.shell_tzresult (option (|Protocol_hash|).(S.HASH.t))) :=
  RPC_context.make_call0 S.current_proposal ctxt block tt tt.