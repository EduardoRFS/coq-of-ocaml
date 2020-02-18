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
Require Tezos.Constants_repr.
Require Tezos.Contract_repr.
Require Tezos.Gas_limit_repr.
Require Tezos.Level_repr.
Require Tezos.Parameters_repr.
Require Tezos.Raw_level_repr.
Require Tezos.Storage_description.
Require Tezos.Tez_repr.

(* extensible_type_definition `error` *)

Inductive missing_key_kind : Set :=
| Del : missing_key_kind
| Copy : missing_key_kind
| Get : missing_key_kind
| __Set : missing_key_kind.

Inductive storage_error : Set :=
| Incompatible_protocol_version : string -> storage_error
| Missing_key : list string -> missing_key_kind -> storage_error
| Existing_key : list string -> storage_error
| Corrupted_data : list string -> storage_error.

(* extensible_type_definition `error` *)

(* extensible_type_definition `error` *)

(* extensible_type_definition `error` *)

Parameter __storage_error_value : forall {a : Set},
  storage_error -> Lwt.t (Error_monad.tzresult a).

Parameter t : Set.

Definition context : Set := t.

Definition root_context : Set := t.

Parameter prepare :
  Int32.t -> Time.t -> Time.t -> (|Fitness|).(S.T.t) -> Context.t ->
  Lwt.t (Error_monad.tzresult context).

Inductive previous_protocol : Set :=
| Genesis : Parameters_repr.t -> previous_protocol
| Alpha_previous : previous_protocol.

Parameter prepare_first_block :
  int32 -> Time.t -> (|Fitness|).(S.T.t) -> Context.t ->
  Lwt.t (Error_monad.tzresult (previous_protocol * context)).

Parameter activate : context -> (|Protocol_hash|).(S.HASH.t) -> Lwt.t t.

Parameter fork_test_chain :
  context -> (|Protocol_hash|).(S.HASH.t) -> Time.t -> Lwt.t t.

Parameter recover : context -> Context.t.

Parameter current_level : context -> Level_repr.t.

Parameter predecessor_timestamp : context -> Time.t.

Parameter current_timestamp : context -> Time.t.

Parameter current_fitness : context -> Int64.t.

Parameter set_current_fitness : context -> Int64.t -> t.

Parameter constants : context -> Constants_repr.parametric.

Parameter patch_constants :
  context -> (Constants_repr.parametric -> Constants_repr.parametric) ->
  Lwt.t context.

Parameter first_level : context -> Raw_level_repr.t.

Parameter add_fees :
  context -> Tez_repr.t -> Lwt.t (Error_monad.tzresult context).

Parameter add_rewards :
  context -> Tez_repr.t -> Lwt.t (Error_monad.tzresult context).

Parameter add_deposit :
  context -> (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Tez_repr.t -> Lwt.t (Error_monad.tzresult context).

Parameter get_fees : context -> Tez_repr.t.

Parameter get_rewards : context -> Tez_repr.t.

Parameter get_deposits :
  context ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.Map).(S.INDEXES_Map.t)
    Tez_repr.t.

(* extensible_type_definition `error` *)

Parameter check_gas_limit : t -> Z.t -> Error_monad.tzresult unit.

Parameter set_gas_limit : t -> Z.t -> t.

Parameter set_gas_unlimited : t -> t.

Parameter gas_level : t -> Gas_limit_repr.t.

Parameter gas_consumed : t -> t -> Z.t.

Parameter block_gas_level : t -> Z.t.

Parameter init_storage_space_to_pay : t -> t.

Parameter update_storage_space_to_pay : t -> Z.t -> t.

Parameter update_allocated_contracts_count : t -> t.

Parameter clear_storage_space_to_pay : t -> t * Z.t * Z.

(* extensible_type_definition `error` *)

Parameter init_origination_nonce : t -> (|Operation_hash|).(S.HASH.t) -> t.

Parameter origination_nonce :
  t -> Error_monad.tzresult Contract_repr.origination_nonce.

Parameter increment_origination_nonce :
  t -> Error_monad.tzresult (t * Contract_repr.origination_nonce).

Parameter unset_origination_nonce : t -> t.

Definition key : Set := list string.

Definition value : Set := MBytes.t.

Module T.
  Record signature {t : Set} : Set := {
    t := t;
    context := t;
    mem : context -> key -> Lwt.t bool;
    dir_mem : context -> key -> Lwt.t bool;
    get : context -> key -> Lwt.t (Error_monad.tzresult value);
    get_option : context -> key -> Lwt.t (option value);
    init : context -> key -> value -> Lwt.t (Error_monad.tzresult context);
    set : context -> key -> value -> Lwt.t (Error_monad.tzresult context);
    init_set : context -> key -> value -> Lwt.t context;
    set_option : context -> key -> option value -> Lwt.t context;
    delete : context -> key -> Lwt.t (Error_monad.tzresult context);
    remove : context -> key -> Lwt.t context;
    remove_rec : context -> key -> Lwt.t context;
    copy : context -> key -> key -> Lwt.t (Error_monad.tzresult context);
    fold : forall {a : Set},
      context -> key -> a -> (Context.dir_or_key -> a -> Lwt.t a) -> Lwt.t a;
    keys : context -> key -> Lwt.t (list key);
    fold_keys : forall {a : Set},
      context -> key -> a -> (key -> a -> Lwt.t a) -> Lwt.t a;
    project : context -> root_context;
    absolute_key : context -> key -> key;
    consume_gas :
      context -> Gas_limit_repr.cost -> Error_monad.tzresult context;
    check_enough_gas :
      context -> Gas_limit_repr.cost -> Error_monad.tzresult unit;
    description : Storage_description.t context;
  }.
  Arguments signature : clear implicits.
End T.

Parameter Included_T : {_ : unit & T.signature t}.

Definition mem : context -> key -> Lwt.t bool := (|Included_T|).(T.mem).

Definition dir_mem : context -> key -> Lwt.t bool := (|Included_T|).(T.dir_mem).

Definition get : context -> key -> Lwt.t (Error_monad.tzresult value) :=
  (|Included_T|).(T.get).

Definition get_option : context -> key -> Lwt.t (option value) :=
  (|Included_T|).(T.get_option).

Definition init :
  context -> key -> value -> Lwt.t (Error_monad.tzresult context) :=
  (|Included_T|).(T.init).

Definition set : context -> key -> value -> Lwt.t (Error_monad.tzresult context)
  := (|Included_T|).(T.set).

Definition init_set : context -> key -> value -> Lwt.t context :=
  (|Included_T|).(T.init_set).

Definition set_option : context -> key -> option value -> Lwt.t context :=
  (|Included_T|).(T.set_option).

Definition delete : context -> key -> Lwt.t (Error_monad.tzresult context) :=
  (|Included_T|).(T.delete).

Definition remove : context -> key -> Lwt.t context :=
  (|Included_T|).(T.remove).

Definition remove_rec : context -> key -> Lwt.t context :=
  (|Included_T|).(T.remove_rec).

Definition copy : context -> key -> key -> Lwt.t (Error_monad.tzresult context)
  := (|Included_T|).(T.copy).

Definition fold {a : Set} :
  context -> key -> a -> (Context.dir_or_key -> a -> Lwt.t a) -> Lwt.t a :=
  (|Included_T|).(T.fold).

Definition keys : context -> key -> Lwt.t (list key) := (|Included_T|).(T.keys).

Definition fold_keys {a : Set} :
  context -> key -> a -> (key -> a -> Lwt.t a) -> Lwt.t a :=
  (|Included_T|).(T.fold_keys).

Definition project : context -> root_context := (|Included_T|).(T.project).

Definition absolute_key : context -> key -> key :=
  (|Included_T|).(T.absolute_key).

Definition consume_gas :
  context -> Gas_limit_repr.cost -> Error_monad.tzresult context :=
  (|Included_T|).(T.consume_gas).

Definition check_enough_gas :
  context -> Gas_limit_repr.cost -> Error_monad.tzresult unit :=
  (|Included_T|).(T.check_enough_gas).

Definition description : Storage_description.t context :=
  (|Included_T|).(T.description).

Parameter reset_internal_nonce : context -> context.

Parameter fresh_internal_nonce : context -> Error_monad.tzresult (context * Z).

Parameter record_internal_nonce : context -> Z -> context.

Parameter internal_nonce_already_recorded : context -> Z -> bool.

Parameter allowed_endorsements :
  context ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.Map).(S.INDEXES_Map.t)
    ((|Signature.Public_key|).(S.SPublic_key.t) * list Z * bool).

Parameter included_endorsements : context -> Z.

Parameter init_endorsements :
  context ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.Map).(S.INDEXES_Map.t)
    ((|Signature.Public_key|).(S.SPublic_key.t) * list Z * bool) -> context.

Parameter record_endorsement :
  context -> (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> context.

Parameter fresh_temporary_big_map : context -> context * Z.t.

Parameter reset_temporary_big_map : context -> context.

Parameter temporary_big_maps : forall {a : Set},
  context -> (a -> Z.t -> Lwt.t a) -> a -> Lwt.t a.
