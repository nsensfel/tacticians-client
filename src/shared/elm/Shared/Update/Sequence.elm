module Shared.Update.Sequence exposing (sequence)

-- Elm -------------------------------------------------------------------------
import List

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
sequence_step : (
      (Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type)))
      -> (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
      -> (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
sequence_step action (model, cmd_list) =
   let (next_model, new_cmd) = (action model) in
      (next_model, (new_cmd :: cmd_list))

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
sequence : (
      (List
         (Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type)))
      )
      -> Struct.Model.Type
      -> (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
sequence actions model =
   let (final_model, cmds) = (List.foldr (sequence_step) (model, []) actions) in
      case cmds of
         [] -> (final_model, Cmd.none)
         [cmd] -> (final_model, cmd)
         _ -> (final_model, (Cmd.batch cmds))
