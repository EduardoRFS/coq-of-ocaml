(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import TypingFlags.Loader.
Unset Guard Checking.

Fixpoint f_map {A B : Set} (f : A -> B) (l : list A) {struct f} : list B :=
  match l with
  | [] => []
  | cons x l => cons (f x) (f_map f l)
  end.

Definition n : Z :=
  let fix sum (l : list Z) {struct l} : Z :=
    match l with
    | [] => 0
    | cons x l => Z.add x (sum l)
    end in
  sum [ 1; 2; 3 ].
