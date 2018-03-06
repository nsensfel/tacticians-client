module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Http

-- Battlemap -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Model

import Update.HandleServerReply.AddChar
import Update.HandleServerReply.SetMap

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

type ServerReply =
   (SetMap Update.HandleServerReply.SetMap.Type)
   | (AddChar Update.HandleServerReply.SetMap.Type)
   | (Other String)
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_command: (List String) -> Struct.Model.Type -> Struct.Model.Type
apply_command cmd model =
   case
      cmd
   of
      ["set_map", data] ->
         (Update.HandleServerReply.SetMap.apply_to model data)

      ["add_char", data] ->
         (Update.HandleServerReply.AddChar.apply_to model data)

      _ ->
         (Struct.Model.invalidate
            model
            (Struct.Error.new
               Struct.Error.Programming
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
      Struct.Model.Type ->
      (Result Http.Error (List (List String))) ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model query_result =
   case query_result of
      (Result.Err error) ->
         (
            (Struct.Model.invalidate
               model
               (Struct.Error.new Struct.Error.Networking (toString error))
            ),
            Cmd.none
         )

      (Result.Ok commands) ->
         ((List.foldl (apply_command) model commands), Cmd.none)
