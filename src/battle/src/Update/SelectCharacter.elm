module Update.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Task

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Action.Scroll

import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
attack_character : (
      Struct.Model.Type ->
      Int ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
attack_character model target_char_id target_char =
   {model |
      char_turn =
         (Struct.CharacterTurn.set_target
            (Just target_char_id)
            model.char_turn
         ),
      ui =
         (Struct.UI.reset_displayed_nav
            (Struct.UI.reset_displayed_tab
               (Struct.UI.set_previous_action Nothing model.ui)
            )
         )
   }

ctrl_or_focus_character : (
      Struct.Model.Type ->
      Int ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
ctrl_or_focus_character model target_char_id target_char =
   if (Struct.Character.is_enabled target_char)
   then
      let
         nav =
            (case (Struct.UI.maybe_get_displayed_nav model.ui) of
               (Just dnav) -> dnav
               Nothing ->
                  (get_character_navigator model.battle target_char)
            )
      in
         {model |
            char_turn =
               (Struct.CharacterTurn.set_navigator
                  nav
                  (Struct.CharacterTurn.set_active_character
                     target_char
                     model.char_turn
                  )
               ),
            ui =
               (Struct.UI.reset_displayed_nav
                  (Struct.UI.reset_displayed_tab
                     (Struct.UI.set_previous_action Nothing model.ui)
                  )
               )
         }
   else
      {model |
         ui =
            (Struct.UI.set_previous_action
               (Just (Struct.UI.SelectedCharacter target_char_id))
               (Struct.UI.set_displayed_nav
                  (get_character_navigator model.battle target_char)
                  model.ui
               )
            )
      }


second_click_on : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
second_click_on target_char_id model =
   if (Struct.CharacterTurn.has_active_character model.char_turn)
   then (Update.CharacterTurn.ToggleTarget.apply_to_ref target_char_id model)
   else (Update.CharacterTurn.apply_to target_char_id model)

first_click_on : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
first_click_on target_char_id model =
   (Update.Sequence.sequence
      [
         (Update.Character.DisplayInfo.apply_to target_char_id),
         (Update.Character.DisplayNavigator.apply_to_ref target_char_id)
      ]
      {model |
         ui =
            (Struct.UI.set_previous_action
               (Just (Struct.UI.SelectedCharacter target_ref))
               model.ui
            )
      }
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model target_char_id =
   if
   (
      (Struct.UI.get_previous_action model.ui)
      ==
      (Just (Struct.UI.SelectedCharacter target_char_id))
   )
   then (second_click_on target_char_id model)
   else (first_click_on target_char_id model)
