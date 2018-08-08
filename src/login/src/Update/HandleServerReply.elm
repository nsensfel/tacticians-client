module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Http

-- Map -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.ServerReply
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
set_session : (
      String ->
      String ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
set_session pid stk current_state =
   case current_state of
      (_, (Just _)) -> current_state

      (model, _) ->
         (
            {model |
               player_id = pid,
               session_token = stk
            },
            Nothing
         )

apply_command : (
      Struct.ServerReply.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
apply_command command current_state =
   case command of
      (Struct.ServerReply.SetSession (pid, stk)) ->
         (set_session pid stk current_state)

      Struct.ServerReply.Okay -> current_state

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Result Http.Error (List Struct.ServerReply.Type)) ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model query_result =
   case query_result of
      (Result.Err error) ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new Struct.Error.Networking (toString error))
               model
            ),
            Cmd.none
         )

      (Result.Ok commands) ->
         (
            (
               case (List.foldl (apply_command) (model, Nothing) commands) of
                  (updated_model, Nothing) -> updated_model
                  (_, (Just error)) -> (Struct.Model.invalidate error model)
            ),
            Cmd.none
         )
