(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Inductive tree : Set :=
| Leaf : tree
| Node : tree -> Z -> tree -> tree.

Fixpoint find (x : Z) (t : tree) : bool :=
  match t with
  | Leaf => false
  | Node t1 x' t2 =>
    if OCaml.Stdlib.lt x x' then
      find x t1
    else
      if OCaml.Stdlib.lt x' x then
        find x t2
      else
        true
  end.
