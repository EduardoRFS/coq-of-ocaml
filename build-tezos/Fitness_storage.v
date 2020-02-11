(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Raw_context.

Definition current : Raw_context.context -> Int64.t :=
  Raw_context.current_fitness.

Definition increase (op_staroptstar : option Z)
  : Raw_context.context -> Raw_context.t :=
  let gap :=
    match op_staroptstar with
    | Some op_starsthstar => op_starsthstar
    | None => 1
    end in
  fun ctxt =>
    let fitness := current ctxt in
    Raw_context.set_current_fitness ctxt (Int64.add (Int64.of_int gap) fitness).