(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import TypingFlags.Loader.
Unset Guard Checking.

Fixpoint map {A B : Set} (f : A -> B) (l : list A) {struct f} : list B :=
  match l with
  | [] => []
  | cons x xs => cons (f x) (map f xs)
  end.

Fixpoint fold {A B : Set} (f : A -> B -> A) (a : A) (l : list B) {struct f}
  : A :=
  match l with
  | [] => a
  | cons x xs => fold f (f a x) xs
  end.

Definition l : list Z := [ 5; 6; 7; 2 ].

Definition n {A : Set} (incr : Z -> A) (plus : Z -> A -> Z) : Z :=
  fold (fun x => fun y => plus x y) 0 (map incr l).
