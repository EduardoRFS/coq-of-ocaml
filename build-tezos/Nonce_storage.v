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
Require Tezos.Level_repr.
Require Tezos.Level_storage.
Require Tezos.Nonce_hash.
Require Tezos.Raw_context.
Require Tezos.Seed_repr.
Require Tezos.Storage_mli. Module Storage := Storage_mli.
Require Tezos.Storage_sigs.
Require Tezos.Tez_repr.

Definition t : Set := Seed_repr.nonce.

Definition nonce : Set := t.

Definition encoding : Data_encoding.t Seed_repr.nonce :=
  Seed_repr.nonce_encoding.

(* ❌ Structure item `typext` not handled. *)
(* type_extension *)

(* ❌ Top-level evaluations are ignored *)
(* top_level_evaluation *)

Definition get_unrevealed (ctxt : Raw_context.t) (level : Level_repr.t)
  : Lwt.t (Error_monad.tzresult Storage.Seed.unrevealed_nonce) :=
  let cur_level := Level_storage.current ctxt in
  match Cycle_repr.pred cur_level.(Level_repr.t.cycle) with
  | None => Error_monad.fail extensible_type_value
  | Some revealed_cycle =>
    if Cycle_repr.op_lt revealed_cycle level.(Level_repr.t.cycle) then
      Error_monad.fail extensible_type_value
    else
      if Cycle_repr.op_lt level.(Level_repr.t.cycle) revealed_cycle then
        Error_monad.fail extensible_type_value
      else
        let=? function_parameter :=
          (|Storage.Seed.Nonce|).(Storage_sigs.Non_iterable_indexed_data_storage.get)
            ctxt level in
        match function_parameter with
        | Storage.Seed.Revealed _ => Error_monad.fail extensible_type_value
        | Storage.Seed.Unrevealed status => Error_monad.__return status
        end
  end.

Definition record_hash
  (ctxt : Raw_context.t) (unrevealed : Storage.Seed.unrevealed_nonce)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let level := Level_storage.current ctxt in
  (|Storage.Seed.Nonce|).(Storage_sigs.Non_iterable_indexed_data_storage.init)
    ctxt level (Storage.Seed.Unrevealed unrevealed).

Definition reveal
  (ctxt : Raw_context.t) (level : Level_repr.t)
  (__nonce_value : Seed_repr.nonce)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let=? unrevealed := get_unrevealed ctxt level in
  let=? '_ :=
    Error_monad.fail_unless
      (Seed_repr.check_hash __nonce_value
        unrevealed.(Storage.Seed.unrevealed_nonce.nonce_hash))
      extensible_type_value in
  let=? ctxt :=
    (|Storage.Seed.Nonce|).(Storage_sigs.Non_iterable_indexed_data_storage.set)
      ctxt level (Storage.Seed.Revealed __nonce_value) in
  Error_monad.__return ctxt.

Module unrevealed.
  Record record : Set := Build {
    nonce_hash : Nonce_hash.t;
    delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t);
    rewards : Tez_repr.t;
    fees : Tez_repr.t }.
  Definition with_nonce_hash nonce_hash (r : record) :=
    Build nonce_hash r.(delegate) r.(rewards) r.(fees).
  Definition with_delegate delegate (r : record) :=
    Build r.(nonce_hash) delegate r.(rewards) r.(fees).
  Definition with_rewards rewards (r : record) :=
    Build r.(nonce_hash) r.(delegate) rewards r.(fees).
  Definition with_fees fees (r : record) :=
    Build r.(nonce_hash) r.(delegate) r.(rewards) fees.
End unrevealed.
Definition unrevealed := unrevealed.record.

Inductive status : Set :=
| Unrevealed : unrevealed -> status
| Revealed : Seed_repr.nonce -> status.

Definition get
  : (|Storage.Seed.Nonce|).(Storage_sigs.Non_iterable_indexed_data_storage.context)
  -> Level_repr.t -> Lwt.t (Error_monad.tzresult Storage.Seed.nonce_status) :=
  (|Storage.Seed.Nonce|).(Storage_sigs.Non_iterable_indexed_data_storage.get).

Definition of_bytes : MBytes.t -> Error_monad.tzresult Seed_repr.nonce :=
  Seed_repr.make_nonce.

Definition __hash_value : Seed_repr.nonce -> Nonce_hash.t :=
  Seed_repr.__hash_value.

Definition check_hash : Seed_repr.nonce -> Nonce_hash.t -> bool :=
  Seed_repr.check_hash.
