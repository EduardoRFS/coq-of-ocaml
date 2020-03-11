(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Alpha_context.
Require Tezos.Services_registration.

Import Alpha_context.

Definition custom_root : RPC_path.context RPC_context.t :=
  RPC_path.op_div (RPC_path.op_div RPC_path.open_root "context") "constants".

Module S.
  Import Data_encoding.
  
  Definition errors
    : RPC_service.service RPC_context.t RPC_context.t unit unit
      Data_encoding.json_schema :=
    RPC_service.get_service
      (Some "Schema for all the RPC errors from this protocol version")
      RPC_query.empty Data_encoding.__json_schema_value
      (RPC_path.op_div custom_root "errors").
  
  Definition all
    : RPC_service.service RPC_context.t RPC_context.t unit unit
      Alpha_context.Constants.t :=
    RPC_service.get_service (Some "All constants") RPC_query.empty
      Alpha_context.Constants.encoding custom_root.
End S.

Definition register (function_parameter : unit) : unit :=
  let '_ := function_parameter in
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  Services_registration.register0 S.all
    (fun ctxt =>
      fun function_parameter =>
        let '_ := function_parameter in
        fun function_parameter =>
          let '_ := function_parameter in
          Error_monad.__return
            {|
              Alpha_context.Constants.t.fixed :=
                Alpha_context.Constants.__fixed_value;
              Alpha_context.Constants.t.parametric :=
                Alpha_context.Constants.__parametric_value ctxt |}).

Definition errors {A : Set} (ctxt : RPC_context.simple A) (block : A)
  : Lwt.t (Error_monad.shell_tzresult Data_encoding.json_schema) :=
  RPC_context.make_call0 S.errors ctxt block tt tt.

Definition all {A : Set} (ctxt : RPC_context.simple A) (block : A)
  : Lwt.t (Error_monad.shell_tzresult Alpha_context.Constants.t) :=
  RPC_context.make_call0 S.all ctxt block tt tt.
