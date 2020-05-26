module Update.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Task

-- Shared ----------------------------------------------------------------------
import Shared.Update.Sequence

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.UI

import Update.Character.DisplayInfo
import Update.Character.DisplayNavigator

import Update.CharacterTurn.ToggleTarget
import Update.CharacterTurn

import Util.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
second_click_on : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
second_click_on target_char_id model =
   if (Struct.CharacterTurn.has_active_character model.char_turn)
   then (Update.CharacterTurn.ToggleTarget.apply_to_ref target_char_id model)
   else
      case (Struct.Battle.get_character target_char_id model.battle) of
         Nothing -> (model, Cmd.none)
         (Just character) ->
            if (Struct.Character.is_enabled character)
            then (Update.CharacterTurn.apply_to character model)
            else (model, Cmd.none)

first_click_on : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
first_click_on target_char_id model =
   (Shared.Update.Sequence.sequence
      [
         (Update.Character.DisplayInfo.apply_to_ref target_char_id),
         (Update.Character.DisplayNavigator.apply_to_ref target_char_id)
      ]
      {model |
         ui =
            (Struct.UI.set_previous_action
               (Just (Struct.UI.SelectedCharacter target_char_id))
               model.ui
            )
      }
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to target_char_id model =
   if
   (
      (Struct.UI.get_previous_action model.ui)
      ==
      (Just (Struct.UI.SelectedCharacter target_char_id))
   )
   then (second_click_on target_char_id model)
   else (first_click_on target_char_id model)
