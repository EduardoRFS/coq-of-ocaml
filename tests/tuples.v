(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Definition t0 : unit := tt.

Definition t1 : ascii * string := ("c" % char, "one").

Definition t2 : Z * Z * Z * bool * bool := (1, 2, 3, false, true).

Definition f {A : Set} (x : A) : A * A := (x, x).

Definition t3 : Z * Z := f 12.
