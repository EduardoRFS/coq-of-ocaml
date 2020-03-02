(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Module Source.
  Record signature {t : Set} : Set := {
    t := t;
    x : t;
  }.
  Arguments signature : clear implicits.
End Source.

Module Target.
  Record signature {t : Set} : Set := {
    t := t;
    y : t;
  }.
  Arguments signature : clear implicits.
End Target.

Definition M :=
  ((let t : Set := Z in
  let x := 12 in
  existT (A := Set) _ _
    {|
      Source.x := x
    |}) : {t : Set & Source.signature t}).

Definition F :=
  fun (X : {t : Set & Source.signature t}) =>
    ((let t : Set := (|X|).(Source.t) in
    let y := (|X|).(Source.x) in
    existT (A := unit) (fun _ => _) tt
      {|
        Target.y := y
      |}) : {_ : unit & Target.signature (|X|).(Source.t)}).

Definition FSubst :=
  fun (X : {t : Set & Source.signature t}) =>
    ((let y := (|X|).(Source.x) in
    existT (A := unit) (fun _ => _) tt
      {|
        Target.y := y
      |}) : {_ : unit & Target.signature (|X|).(Source.t)}).

Definition Sum :=
  fun (X : {_ : unit & Source.signature Z}) =>
    fun (Y : {_ : unit & Source.signature Z}) =>
      ((let t : Set := Z in
      let y := Z.add (|X|).(Source.x) (|Y|).(Source.x) in
      existT (A := Set) _ _
        {|
          Target.y := y
        |}) : {t : Set & Target.signature t}).
