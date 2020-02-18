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
Require Tezos.Constants_services_mli. Module Constants_services := Constants_services_mli.
Require Tezos.Contract_services_mli. Module Contract_services := Contract_services_mli.
Require Tezos.Delegate_services_mli. Module Delegate_services := Delegate_services_mli.
Require Tezos.Helpers_services_mli. Module Helpers_services := Helpers_services_mli.
Require Tezos.Nonce_hash.
Require Tezos.Voting_services_mli. Module Voting_services := Voting_services_mli.

Import Alpha_context.

Module Seed.
  Parameter get : forall {E F H J K a b c i o q : Set},
    (((RPC_service.t
      ((* `PUT *) unit + (* `GET *) unit + (* `DELETE *) unit + (* `POST *) unit
        + (* `PATCH *) unit) RPC_context.t RPC_context.t q i o -> a -> q -> i ->
    Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `PUT *) unit + (* `GET *) unit + (* `DELETE *) unit +
          (* `POST *) unit + (* `PATCH *) unit) RPC_context.t
        (RPC_context.t * a) q i o -> a -> a -> q -> i ->
      Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
        (((RPC_service.t
          ((* `PUT *) unit + (* `GET *) unit + (* `DELETE *) unit +
            (* `POST *) unit + (* `PATCH *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> a -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (H * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `PUT *) unit + (* `GET *) unit + (* `DELETE *) unit +
              (* `POST *) unit + (* `PATCH *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> a -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
    Lwt.t (Error_monad.shell_tzresult Alpha_context.Seed.seed).
End Seed.

Module Nonce.
  Inductive info : Set :=
  | Revealed : Alpha_context.Nonce.t -> info
  | Missing : Nonce_hash.t -> info
  | Forgotten : info.
  
  Parameter get : forall {E F H J K a b c i o q : Set},
    (((RPC_service.t
      ((* `PUT *) unit + (* `GET *) unit + (* `DELETE *) unit + (* `POST *) unit
        + (* `PATCH *) unit) RPC_context.t RPC_context.t q i o -> a -> q -> i ->
    Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t
        ((* `PUT *) unit + (* `GET *) unit + (* `DELETE *) unit +
          (* `POST *) unit + (* `PATCH *) unit) RPC_context.t
        (RPC_context.t * a) q i o -> a -> a -> q -> i ->
      Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
        (((RPC_service.t
          ((* `PUT *) unit + (* `GET *) unit + (* `DELETE *) unit +
            (* `POST *) unit + (* `PATCH *) unit) RPC_context.t
          ((RPC_context.t * a) * b) q i o -> a -> a -> b -> q -> i ->
        Lwt.t (Error_monad.shell_tzresult o)) * (H * a * b * q * i * o)) *
          (((RPC_service.t
            ((* `PUT *) unit + (* `GET *) unit + (* `DELETE *) unit +
              (* `POST *) unit + (* `PATCH *) unit) RPC_context.t
            (((RPC_context.t * a) * b) * c) q i o -> a -> a -> b -> c -> q ->
          i -> Lwt.t (Error_monad.shell_tzresult o)) *
            (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
    Alpha_context.Raw_level.t -> Lwt.t (Error_monad.shell_tzresult info).
End Nonce.

Module Contract := Contract_services.

Module Constants := Constants_services.

Module Delegate := Delegate_services.

Module Helpers := Helpers_services.

Module Forge := Helpers_services.Forge.

Module Parse := Helpers_services.Parse.

Module Voting := Voting_services.

Parameter register : unit -> unit.
