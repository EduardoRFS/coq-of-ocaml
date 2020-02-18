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

Fixpoint op_minusminusgt
  (i : (|Compare.Int|).(Compare.S.t)) (j : (|Compare.Int|).(Compare.S.t))
  {struct i} : list (|Compare.Int|).(Compare.S.t) :=
  if (|Compare.Int|).(Compare.S.op_gt) i j then
    nil
  else
    cons i (op_minusminusgt (Pervasives.succ i) j).

Fixpoint op_minusminusminusgt
  (i : (|Compare.Int32|).(Compare.S.t)) (j : (|Compare.Int32|).(Compare.S.t))
  {struct i} : list (|Compare.Int32|).(Compare.S.t) :=
  if (|Compare.Int32|).(Compare.S.op_gt) i j then
    nil
  else
    cons i (op_minusminusminusgt (Int32.succ i) j).

Fixpoint do_slashes
  (delim : (|Compare.Char|).(Compare.S.t)) (path : string)
  (l : (|Compare.Int|).(Compare.S.t)) (acc : list string)
  (limit : (|Compare.Int|).(Compare.S.t)) (i : (|Compare.Int|).(Compare.S.t))
  {struct delim} : list string :=
  if (|Compare.Int|).(Compare.S.op_gteq) i l then
    List.rev acc
  else
    if (|Compare.Char|).(Compare.S.op_eq) (String.get path i) delim then
      do_slashes delim path l acc limit (Pervasives.op_plus i 1)
    else
      do_split delim path l acc limit i

with do_split
  (delim : (|Compare.Char|).(Compare.S.t)) (path : string)
  (l : (|Compare.Int|).(Compare.S.t)) (acc : list string)
  (limit : (|Compare.Int|).(Compare.S.t)) (i : (|Compare.Int|).(Compare.S.t))
  {struct delim} : list string :=
  if (|Compare.Int|).(Compare.S.op_lteq) limit 0 then
    if (|Compare.Int|).(Compare.S.op_eq) i l then
      List.rev acc
    else
      List.rev (cons (String.sub path i (Pervasives.op_minus l i)) acc)
  else
    do_component delim path l acc (Pervasives.pred limit) i i

with do_component
  (delim : (|Compare.Char|).(Compare.S.t)) (path : string)
  (l : (|Compare.Int|).(Compare.S.t)) (acc : list string)
  (limit : (|Compare.Int|).(Compare.S.t)) (i : (|Compare.Int|).(Compare.S.t))
  (j : (|Compare.Int|).(Compare.S.t)) {struct delim} : list string :=
  if (|Compare.Int|).(Compare.S.op_gteq) j l then
    if (|Compare.Int|).(Compare.S.op_eq) i j then
      List.rev acc
    else
      List.rev (cons (String.sub path i (Pervasives.op_minus j i)) acc)
  else
    if (|Compare.Char|).(Compare.S.op_eq) (String.get path j) delim then
      do_slashes delim path l
        (cons (String.sub path i (Pervasives.op_minus j i)) acc) limit j
    else
      do_component delim path l acc limit i (Pervasives.op_plus j 1).

Definition split
  (delim : (|Compare.Char|).(Compare.S.t))
  (op_staroptstar : option (|Compare.Int|).(Compare.S.t))
  : string -> list string :=
  let limit :=
    match op_staroptstar with
    | Some op_starsthstar => op_starsthstar
    | None => Pervasives.max_int
    end in
  fun path =>
    let l := String.length path in
    if (|Compare.Int|).(Compare.S.op_gt) limit 0 then
      do_slashes delim path l nil limit 0
    else
      [ path ].

Definition pp_print_paragraph (ppf : Format.formatter) (description : string)
  : unit :=
  Format.fprintf ppf
    (CamlinternalFormatBasics.Format
      (CamlinternalFormatBasics.Formatting_gen
        (CamlinternalFormatBasics.Open_box
          (CamlinternalFormatBasics.Format
            CamlinternalFormatBasics.End_of_format ""))
        (CamlinternalFormatBasics.Alpha
          (CamlinternalFormatBasics.Formatting_lit
            CamlinternalFormatBasics.Close_box
            CamlinternalFormatBasics.End_of_format))) "@[%a@]")
    (Format.pp_print_list (Some Format.pp_print_space) Format.pp_print_string)
    (split " " % char None description).

Definition take {A : Set} (n : (|Compare.Int|).(Compare.S.t)) (l : list A)
  : option (list A * list A) :=
  let fix loop {B : Set}
    (acc : list B) (n : (|Compare.Int|).(Compare.S.t)) (xs : list B)
    {struct acc} : option (list B * list B) :=
    if (|Compare.Int|).(Compare.S.op_lteq) n 0 then
      Some ((List.rev acc), xs)
    else
      match xs with
      | [] => None
      | cons x xs => loop (cons x acc) (Pervasives.op_minus n 1) xs
      end in
  loop nil n l.

Definition remove_prefix
  (prefix : (|Compare.String|).(Compare.S.t)) (s : string) : option string :=
  let x := String.length prefix in
  let n := String.length s in
  if
    Pervasives.op_andand ((|Compare.Int|).(Compare.S.op_gteq) n x)
      ((|Compare.String|).(Compare.S.op_eq) (String.sub s 0 x) prefix) then
    Some (String.sub s x (Pervasives.op_minus n x))
  else
    None.

Fixpoint remove_elem_from_list {A : Set}
  (nb : (|Compare.Int|).(Compare.S.t)) (function_parameter : list A) {struct nb}
  : list A :=
  match
    (function_parameter,
      match function_parameter with
      | (cons _ _) as l => (|Compare.Int|).(Compare.S.op_lteq) nb 0
      | _ => false
      end) with
  | ([], _) => nil
  | ((cons _ _) as l, true) => l
  | (cons _ tl, _) => remove_elem_from_list (Pervasives.op_minus nb 1) tl
  end.
