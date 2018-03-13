module Update.HandleServerReply exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Http

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.ServerReply
import Struct.TurnResult
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
add_character : (
      Struct.Character.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
add_character char current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) ->
         (
            (Struct.Model.add_character
               char
               model
            ),
            Nothing
         )

set_map : (
      Struct.Battlemap.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
set_map map current_state =
   case current_state of
      (_, (Just _)) -> current_state
      (model, _) ->
         (
            {model | battlemap = map},
            Nothing
         )

add_to_timeline : (
      (List Struct.TurnResult.Type) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
add_to_timeline turn_results current_state =
   case current_state of
      (_, (Just _)) -> current_state

      (model, _) ->
         let
            updated_characters =
               (List.foldl
                  (Struct.TurnResult.apply_to_characters)
                  model.characters
                  turn_results
               )
         in
            (
               {model |
                  timeline =
                     (Array.append
                        model.timeline
                        (Array.fromList turn_results)
                     ),
                  ui =
                     (Struct.UI.set_displayed_tab
                        model.ui
                        Struct.UI.TimelineTab
                     ),
                  characters = updated_characters
               },
               Nothing
            )

set_timeline : (
      (List Struct.TurnResult.Type) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
set_timeline turn_results current_state =
   case current_state of
      (_, (Just _)) -> current_state

      (model, _) ->
         (
            {model | timeline = (Array.fromList turn_results)},
            Nothing
         )

apply_command : (
      Struct.ServerReply.Type ->
      (Struct.Model.Type, (Maybe Struct.Error.Type)) ->
      (Struct.Model.Type, (Maybe Struct.Error.Type))
   )
apply_command command current_state =
   case command of
      (Struct.ServerReply.AddCharacter char) ->
         (add_character char current_state)

      (Struct.ServerReply.SetMap map) ->
         (set_map map current_state)

      (Struct.ServerReply.TurnResults results) ->
         (add_to_timeline results current_state)

      (Struct.ServerReply.SetTimeline timeline) ->
         (set_timeline timeline current_state)

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
