module Model.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Model
import Error
import Event

import Model.HandleServerReply.SetMap
import Model.HandleServerReply.AddChar

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_command: (List String) -> Model.Type -> Model.Type
apply_command cmd model =
   case
      cmd
   of
      ["set_map", data] ->
         (Model.HandleServerReply.SetMap.apply_to model data)

      ["add_char", data] ->
         (Model.HandleServerReply.AddChar.apply_to model data)

      _ ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               (
                  "Received invalid command from server:"
                  ++ (toString cmd)
               )
            )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Model.Type ->
      (List (List String)) ->
      (Model.Type, (Cmd Event.Type))
   )
apply_to model serialized_commands =
   ((List.foldl (apply_command) model serialized_commands), Cmd.none)
