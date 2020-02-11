(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Constants_repr.
Require Tezos.Contract_repr.
Require Tezos.Contract_storage.
Require Tezos.Cycle_repr.
Require Tezos.Delegate_storage.
Require Tezos.Misc.
Require Tezos.Parameters_repr.
Require Tezos.Raw_context.
Require Tezos.Script_repr.
Require Tezos.Storage.
Require Tezos.Tez_repr.

Import Misc.

Definition init_account
  (ctxt : Raw_context.t)
  (function_parameter : Parameters_repr.bootstrap_account)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let '{|
    Parameters_repr.bootstrap_account.public_key_hash := public_key_hash;
      Parameters_repr.bootstrap_account.public_key := public_key;
      Parameters_repr.bootstrap_account.amount := amount
      |} := function_parameter in
  let contract := Contract_repr.implicit_contract public_key_hash in
  Error_monad.op_gtgteqquestion (Contract_storage.credit ctxt contract amount)
    (fun ctxt =>
      match public_key with
      | Some public_key =>
        Error_monad.op_gtgteqquestion
          (Contract_storage.reveal_manager_key ctxt public_key_hash public_key)
          (fun ctxt =>
            Error_monad.op_gtgteqquestion
              (Delegate_storage.set ctxt contract (Some public_key_hash))
              (fun ctxt => Error_monad.__return ctxt))
      | None => Error_monad.__return ctxt
      end).

Definition init_contract
  (typecheck :
    Raw_context.t -> Script_repr.t ->
    Lwt.t
      (Error_monad.tzresult
        ((Script_repr.t * option Contract_storage.big_map_diff) * Raw_context.t)))
  (ctxt : Raw_context.t)
  (function_parameter : Parameters_repr.bootstrap_contract)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let '{|
    Parameters_repr.bootstrap_contract.delegate := delegate;
      Parameters_repr.bootstrap_contract.amount := amount;
      Parameters_repr.bootstrap_contract.script := script
      |} := function_parameter in
  Error_monad.op_gtgteqquestion
    (Contract_storage.fresh_contract_from_current_nonce ctxt)
    (fun function_parameter =>
      let '(ctxt, contract) := function_parameter in
      Error_monad.op_gtgteqquestion (typecheck ctxt script)
        (fun function_parameter =>
          let '(script, ctxt) := function_parameter in
          Error_monad.op_gtgteqquestion
            (Contract_storage.originate ctxt (Some true) contract amount script
              (Some delegate)) (fun ctxt => Error_monad.__return ctxt))).

Definition init
  (ctxt : Raw_context.t)
  (typecheck :
    Raw_context.t -> Script_repr.t ->
    Lwt.t
      (Error_monad.tzresult
        ((Script_repr.t * option Contract_storage.big_map_diff) * Raw_context.t)))
  (ramp_up_cycles : option Z) (no_reward_cycles : option Z)
  (accounts : list Parameters_repr.bootstrap_account)
  (contracts : list Parameters_repr.bootstrap_contract)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let __nonce_value :=
    (|Operation_hash|).(S.HASH.hash_bytes) None
      [ MBytes.of_string "Un festival de GADT." ] in
  let ctxt := Raw_context.init_origination_nonce ctxt __nonce_value in
  Error_monad.op_gtgteqquestion
    (Error_monad.fold_left_s init_account ctxt accounts)
    (fun ctxt =>
      Error_monad.op_gtgteqquestion
        (Error_monad.fold_left_s (init_contract typecheck) ctxt contracts)
        (fun ctxt =>
          Error_monad.op_gtgteqquestion
            match no_reward_cycles with
            | None => Error_monad.__return ctxt
            | Some cycles =>
              let constants := Raw_context.constants ctxt in
              Error_monad.op_gtgteq
                (Raw_context.patch_constants ctxt
                  (fun c =>
                    Constants_repr.parametric.with_endorsement_reward
                      Tez_repr.zero
                      (Constants_repr.parametric.with_block_reward Tez_repr.zero
                        c)))
                (fun ctxt =>
                  Storage.Ramp_up.Rewards.init ctxt
                    (Cycle_repr.of_int32_exn (Int32.of_int cycles))
                    (constants.(Constants_repr.parametric.block_reward),
                      constants.(Constants_repr.parametric.endorsement_reward)))
            end
            (fun ctxt =>
              match ramp_up_cycles with
              | None => Error_monad.__return ctxt
              | Some cycles =>
                let constants := Raw_context.constants ctxt in
                Error_monad.op_gtgteqquestion
                  (Lwt.__return
                    (Tez_repr.op_divquestion
                      constants.(Constants_repr.parametric.block_security_deposit)
                      (Int64.of_int cycles)))
                  (fun block_step =>
                    Error_monad.op_gtgteqquestion
                      (Lwt.__return
                        (Tez_repr.op_divquestion
                          constants.(Constants_repr.parametric.endorsement_security_deposit)
                          (Int64.of_int cycles)))
                      (fun endorsement_step =>
                        Error_monad.op_gtgteq
                          (Raw_context.patch_constants ctxt
                            (fun c =>
                              Constants_repr.parametric.with_endorsement_security_deposit
                                Tez_repr.zero
                                (Constants_repr.parametric.with_block_security_deposit
                                  Tez_repr.zero c)))
                          (fun ctxt =>
                            Error_monad.op_gtgteqquestion
                              (Error_monad.fold_left_s
                                (fun ctxt =>
                                  fun cycle =>
                                    Error_monad.op_gtgteqquestion
                                      (Lwt.__return
                                        (Tez_repr.op_starquestion block_step
                                          (Int64.of_int cycle)))
                                      (fun block_security_deposit =>
                                        Error_monad.op_gtgteqquestion
                                          (Lwt.__return
                                            (Tez_repr.op_starquestion
                                              endorsement_step
                                              (Int64.of_int cycle)))
                                          (fun endorsement_security_deposit =>
                                            let cycle :=
                                              Cycle_repr.of_int32_exn
                                                (Int32.of_int cycle) in
                                            Storage.Ramp_up.Security_deposits.init
                                              ctxt cycle
                                              (block_security_deposit,
                                                endorsement_security_deposit))))
                                ctxt
                                (Misc.op_minusminusgt 1
                                  (Pervasives.op_minus cycles 1)))
                              (fun ctxt =>
                                Error_monad.op_gtgteqquestion
                                  (Storage.Ramp_up.Security_deposits.init ctxt
                                    (Cycle_repr.of_int32_exn
                                      (Int32.of_int cycles))
                                    (constants.(Constants_repr.parametric.block_security_deposit),
                                      constants.(Constants_repr.parametric.endorsement_security_deposit)))
                                  (fun ctxt => Error_monad.__return ctxt)))))
              end))).

Definition cycle_end
  (ctxt : Storage.Ramp_up.Rewards.context) (last_cycle : Cycle_repr.cycle)
  : Lwt.t (Error_monad.tzresult Storage.Ramp_up.Rewards.context) :=
  let next_cycle := Cycle_repr.succ last_cycle in
  Error_monad.op_gtgteqquestion
    (Error_monad.op_gtgteqquestion
      (Storage.Ramp_up.Rewards.get_option ctxt next_cycle)
      (fun function_parameter =>
        match function_parameter with
        | None => Error_monad.__return ctxt
        | Some (block_reward, endorsement_reward) =>
          Error_monad.op_gtgteqquestion
            (Storage.Ramp_up.Rewards.delete ctxt next_cycle)
            (fun ctxt =>
              Error_monad.op_gtgteq
                (Raw_context.patch_constants ctxt
                  (fun c =>
                    Constants_repr.parametric.with_endorsement_reward
                      endorsement_reward
                      (Constants_repr.parametric.with_block_reward block_reward
                        c))) (fun ctxt => Error_monad.__return ctxt))
        end))
    (fun ctxt =>
      Error_monad.op_gtgteqquestion
        (Storage.Ramp_up.Security_deposits.get_option ctxt next_cycle)
        (fun function_parameter =>
          match function_parameter with
          | None => Error_monad.__return ctxt
          | Some (block_security_deposit, endorsement_security_deposit) =>
            Error_monad.op_gtgteqquestion
              (Storage.Ramp_up.Security_deposits.delete ctxt next_cycle)
              (fun ctxt =>
                Error_monad.op_gtgteq
                  (Raw_context.patch_constants ctxt
                    (fun c =>
                      Constants_repr.parametric.with_endorsement_security_deposit
                        endorsement_security_deposit
                        (Constants_repr.parametric.with_block_security_deposit
                          block_security_deposit c)))
                  (fun ctxt => Error_monad.__return ctxt))
          end)).