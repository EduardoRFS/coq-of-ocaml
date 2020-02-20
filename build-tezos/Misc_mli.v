(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Import Environment.Notations.

Definition lazyt (a : Set) : Set := unit -> a.

Inductive lazy_list_t (a : Set) : Set :=
| LCons :
  a -> lazyt (Lwt.t (Error_monad.tzresult (lazy_list_t a))) -> lazy_list_t a.

Arguments LCons {_}.

Definition lazy_list (a : Set) : Set :=
  Lwt.t (Error_monad.tzresult (lazy_list_t a)).

Parameter op_minusminusgt : int -> int -> list int.

Parameter op_minusminusminusgt : Int32.t -> Int32.t -> list Int32.t.

Parameter pp_print_paragraph : Format.formatter -> string -> unit.

Parameter take : forall {a : Set}, int -> list a -> option (list a * list a).

Parameter remove_prefix : string -> string -> option string.

Parameter remove_elem_from_list : forall {a : Set}, int -> list a -> list a.
