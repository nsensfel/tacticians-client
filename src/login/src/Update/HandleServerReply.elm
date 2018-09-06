module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Http

-- Map -------------------------------------------------------------------
import Action.Ports

import Struct.Error
import Struct.Event
import Struct.Model
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
set_session : (
      String ->
      String ->
      (
         Struct.Model.Type,
         (Maybe Struct.Error.Type),
         (List (Cmd Struct.Event.Type))
      ) ->
      (
         Struct.Model.Type,
         (Maybe Struct.Error.Type),
         (List (Cmd Struct.Event.Type))
      )
   )
set_session pid stk current_state =
   case current_state of
      (_, (Just _), _) -> current_state

      (model, _, cmd_list) ->
         (
            {model |
               player_id = pid,
               session_token = stk
            },
            Nothing,
            (
               (Action.Ports.store_new_session (pid, stk))
               :: cmd_list
            )
         )

apply_command : (
      Struct.ServerReply.Type ->
      (
         Struct.Model.Type,
         (Maybe Struct.Error.Type),
         (List (Cmd Struct.Event.Type))
      ) ->
      (
         Struct.Model.Type,
         (Maybe Struct.Error.Type),
         (List (Cmd Struct.Event.Type))
      )
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
            case
               (List.foldl
                  (apply_command)
                  (model, Nothing, [])
                  commands
               )
            of
               (updated_model, Nothing, cmds) ->
                  (
                     updated_model,
                     (Cmd.batch cmds)
                  )

               (_, (Just error), _) ->
                  (
                     (Struct.Model.invalidate error model),
                     Cmd.none
                  )
         )
