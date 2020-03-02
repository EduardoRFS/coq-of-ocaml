(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.

Definition random_state_hash : string := "L@\204".

Definition Blake2BModule :=
  (Blake2B.Make
    (existT (A := unit) (fun _ => _) tt
      {|
        Blake2B.SRegister.register_encoding {_} := Base58.register_encoding
      |}))
    (let name := "random" in
    let title := "A random generation state" in
    let b58check_prefix := random_state_hash in
    let size {A : Set} : option A :=
      None in
    existT (A := unit) (fun _ => _) tt
      {|
        Blake2B.PrefixedName.name := name;
        Blake2B.PrefixedName.title := title;
        Blake2B.PrefixedName.size := size;
        Blake2B.PrefixedName.b58check_prefix := b58check_prefix
      |}).

Definition t := (|Blake2BModule|).(S.HASH.t).

Definition name := (|Blake2BModule|).(S.HASH.name).

Definition title := (|Blake2BModule|).(S.HASH.title).

Definition pp := (|Blake2BModule|).(S.HASH.pp).

Definition pp_short := (|Blake2BModule|).(S.HASH.pp_short).

Definition op_eq := (|Blake2BModule|).(S.HASH.op_eq).

Definition op_ltgt := (|Blake2BModule|).(S.HASH.op_ltgt).

Definition op_lt := (|Blake2BModule|).(S.HASH.op_lt).

Definition op_lteq := (|Blake2BModule|).(S.HASH.op_lteq).

Definition op_gteq := (|Blake2BModule|).(S.HASH.op_gteq).

Definition op_gt := (|Blake2BModule|).(S.HASH.op_gt).

Definition compare := (|Blake2BModule|).(S.HASH.compare).

Definition equal := (|Blake2BModule|).(S.HASH.equal).

Definition max := (|Blake2BModule|).(S.HASH.max).

Definition min := (|Blake2BModule|).(S.HASH.min).

Definition hash_bytes := (|Blake2BModule|).(S.HASH.hash_bytes).

Definition hash_string := (|Blake2BModule|).(S.HASH.hash_string).

Definition zero := (|Blake2BModule|).(S.HASH.zero).

Definition size := (|Blake2BModule|).(S.HASH.size).

Definition to_bytes := (|Blake2BModule|).(S.HASH.to_bytes).

Definition of_bytes_opt := (|Blake2BModule|).(S.HASH.of_bytes_opt).

Definition of_bytes_exn := (|Blake2BModule|).(S.HASH.of_bytes_exn).

Definition to_b58check := (|Blake2BModule|).(S.HASH.to_b58check).

Definition to_short_b58check := (|Blake2BModule|).(S.HASH.to_short_b58check).

Definition of_b58check_exn := (|Blake2BModule|).(S.HASH.of_b58check_exn).

Definition of_b58check_opt := (|Blake2BModule|).(S.HASH.of_b58check_opt).

Definition b58check_encoding := (|Blake2BModule|).(S.HASH.b58check_encoding).

Definition encoding := (|Blake2BModule|).(S.HASH.encoding).

Definition rpc_arg := (|Blake2BModule|).(S.HASH.rpc_arg).

Definition to_path := (|Blake2BModule|).(S.HASH.to_path).

Definition of_path := (|Blake2BModule|).(S.HASH.of_path).

Definition of_path_exn := (|Blake2BModule|).(S.HASH.of_path_exn).

Definition prefix_path := (|Blake2BModule|).(S.HASH.prefix_path).

Definition path_length := (|Blake2BModule|).(S.HASH.path_length).

(* ❌ Top-level evaluations are ignored *)
(* top_level_evaluation *)
