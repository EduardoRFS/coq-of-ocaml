(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Definition f (n : int) (b : bool) : int :=
  if b then
    Z.add n 1
  else
    Z.sub n 1.

Definition id {a : Set} (x : a) : a := x.
