(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Module M.
  Definition n : Z := 12.
End M.

Module N.
  Definition n : bool := true.
  
  Definition x : bool := n.
  
  Import M.
  
  Definition y : Z := n.
End N.

Definition b : bool := N.n.

Import N.

Definition b' : bool := N.n.
