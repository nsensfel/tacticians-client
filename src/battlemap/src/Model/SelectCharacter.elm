module Model.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Direction

import Character

import UI

import Model
import Model.RequestDirection

import Error

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
autopilot : Battlemap.Direction.Type -> Model.Type -> Model.Type
autopilot dir model =
   (Model.RequestDirection.apply_to model dir)

attack_character : (
      Model.Type ->
      Character.Ref ->
      Character.Ref ->
      Character.Type ->
      Model.Type
   )
attack_character model main_char_id target_char_id target_char =
   {model |
      ui =
         (UI.set_previous_action
            model.ui
            (Just (UI.AttackedCharacter target_char_id))
         )
   }

select_character : (
      Model.Type ->
      Character.Ref ->
      Character.Type ->
      Model.Type
   )
select_character model target_char_id target_char =
   if ((Character.is_enabled target_char))
   then
      {model |
         state = Model.Default,
         controlled_character = (Just target_char_id),
         ui = (UI.set_previous_action model.ui Nothing),
         battlemap =
            (Battlemap.set_navigator
               (Character.get_location target_char)
               (Character.get_movement_points target_char)
               (Character.get_attack_range target_char)
               (Dict.values model.characters)
               model.battlemap
            )
      }
   else
      {model |
         ui =
            (UI.set_previous_action
               model.ui
               (Just (UI.SelectedCharacter target_char_id))
            )
      }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Model.Type -> Character.Ref -> Model.Type
apply_to model target_char_id =
   if
   (
      (UI.get_previous_action model.ui)
      ==
      (Just (UI.SelectedCharacter target_char_id))
   )
   then
      case (Dict.get target_char_id model.characters) of
         (Just target_char) ->
            case model.controlled_character of
               (Just main_char_id) ->
                  (attack_character
                     model
                     main_char_id
                     target_char_id
                     target_char
                  )

               _ -> (select_character model target_char_id target_char)

         Nothing ->
            (Model.invalidate
               model
               (Error.new
                  Error.Programming
                  "SelectCharacter: Unknown char selected."
               )
            )
   else
      {model |
         ui =
            (UI.set_previous_action
               model.ui
               (Just (UI.SelectedCharacter target_char_id))
            )
      }
