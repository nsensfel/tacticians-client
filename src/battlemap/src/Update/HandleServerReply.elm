module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Http

-- Battlemap -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.ServerReply
import Struct.Model

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_command : (
      Struct.ServerReply.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
apply_command command current_state =
   case (command, current_state) of
      (_, (_, (Just error))) -> current_state

      (
         (Struct.ServerReply.AddCharacter char),
         (model, _)
      ) ->
         current_state

      (
         (Struct.ServerReply.SetMap map),
         (model, _)
      ) ->
         current_state

      (_, (model, _)) ->
         (
            model,
            (Just
               (Struct.Error.new
                  Struct.Error.Unimplemented
                  "Unimplemented server command received"
               )
            )
         )
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
               model
               (Struct.Error.new Struct.Error.Networking (toString error))
            ),
            Cmd.none
         )

      (Result.Ok commands) ->
         (
            (
               case (List.foldl (apply_command) (model, Nothing) commands) of
                  (updated_model, Nothing) -> updated_model
                  (_, (Just error)) -> (Struct.Model.invalidate model error)
            ),
            Cmd.none
         )
