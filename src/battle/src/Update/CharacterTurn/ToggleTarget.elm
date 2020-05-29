module Update.CharacterTurn.ToggleTarget exposing (apply_to, apply_to_ref)

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Constants.DisplayEffects

import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
can_target_character : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Bool
   )
can_target_character model target =
   (
      (Struct.Character.is_alive target)
      &&
      (
         case
            (Struct.CharacterTurn.maybe_get_navigator
               model.char_turn
            )
         of
            (Just nav) ->
               case
                  (Struct.Navigator.maybe_get_path_to
                     (BattleMap.Struct.Location.get_ref
                        (Struct.Character.get_location target)
                     )
                     nav
                  )
               of
                  (Just _) -> True
                  _ -> False

            _ ->
               False
      )
   )

toggle_attack_character : (
      Struct.Model.Type ->
      Int ->
      Struct.Model.Type
   )
toggle_attack_character model target_char_id =
   {model |
      char_turn =
         (Struct.CharacterTurn.toggle_target_index
            target_char_id
            model.char_turn
         ),
      battle =
         (Struct.Battle.update_character
            target_char_id
            (Struct.Character.toggle_extra_display_effect
               Constants.DisplayEffects.target
            )
            model.battle
         ),
      ui =
         (Struct.UI.clear_displayed_navigator
            (Struct.UI.clear_displayed_tab
               (Struct.UI.set_previous_action Nothing model.ui)
            )
         )
   }

undo_attack_character : (
      Struct.Model.Type ->
      Int ->
      Struct.Model.Type
   )
undo_attack_character model target_char_id =
   {model |
      char_turn =
         (Struct.CharacterTurn.remove_target_index
            target_char_id
            model.char_turn
         ),
      battle =
         (Struct.Battle.update_character
            target_char_id
            (Struct.Character.remove_extra_display_effect
               Constants.DisplayEffects.target
            )
            model.battle
         ),
      ui =
         (Struct.UI.clear_displayed_navigator
            (Struct.UI.clear_displayed_tab
               (Struct.UI.set_previous_action Nothing model.ui)
            )
         )
   }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Character.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to target model =
   (
      (
         let target_ix = (Struct.Character.get_index target) in
            if (can_target_character model target)
            then (toggle_attack_character model target_ix)
            else (undo_attack_character model target_ix)
      ),
      Cmd.none
   )

apply_to_ref : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to_ref target_ix model =
   case (Struct.Battle.get_character target_ix model.battle) of
      Nothing -> (model, Cmd.none)
      (Just char) -> (apply_to char model)
