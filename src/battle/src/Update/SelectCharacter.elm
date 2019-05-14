module Update.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Task

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Statistics

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Action.Scroll

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
get_character_navigator : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Navigator.Type
   )
get_character_navigator model char =
   let
      base_char = (Struct.Character.get_base_character char)
      weapon = (BattleCharacters.Struct.Character.get_active_weapon base_char)
   in
      (Struct.Navigator.new
         (Struct.Character.get_location char)
         (Battle.Struct.Statistics.get_movement_points
            (BattleCharacters.Struct.Character.get_statistics base_char)
         )
         (BattleCharacters.Struct.Weapon.get_defense_range weapon)
         (BattleCharacters.Struct.Weapon.get_attack_range weapon)
         (BattleMap.Struct.Map.get_tile_data_function
            model.map
            (List.map
               (Struct.Character.get_location)
               (Array.toList model.characters)
            )
            (Struct.Character.get_location char)
         )
      )

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
            (case (Struct.UI.try_getting_displayed_nav model.ui) of
               (Just dnav) -> dnav
               Nothing ->
                  (get_character_navigator model target_char)
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
                  (get_character_navigator model target_char)
                  model.ui
               )
            )
      }

can_target_character : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Bool
   )
can_target_character model target =
   (
      (Struct.CharacterTurn.can_select_target model.char_turn)
      && (Struct.Character.is_alive target)
      &&
      (
         case
            (Struct.CharacterTurn.try_getting_navigator
               model.char_turn
            )
         of
            (Just nav) ->
               case
                  (Struct.Navigator.try_getting_path_to
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

second_click_on : (
      Struct.Model.Type ->
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
second_click_on model target_char_id =
   case (Array.get target_char_id model.characters) of
      (Just target_char) ->
         case
            (
               (Struct.CharacterTurn.try_getting_active_character
                  model.char_turn
               ),
               (Struct.CharacterTurn.try_getting_target model.char_turn)
            )
         of
            ((Just _), (Just char_turn_target_id)) ->
               if (char_turn_target_id == target_char_id)
               then
                  (
                     model,
                     Cmd.none
                  )
               else
                  (
                     (ctrl_or_focus_character model target_char_id target_char),
                     (Task.attempt
                        (Struct.Event.attempted)
                        (Action.Scroll.to
                           (Struct.Character.get_location target_char)
                           model.ui
                        )
                     )
                  )

            ((Just _), Nothing) ->
               if (can_target_character model target_char)
               then
                  (
                     (attack_character
                        model
                        target_char_id
                        target_char
                     ),
                     Cmd.none
                  )
               else
                  (
                     (ctrl_or_focus_character model target_char_id target_char),
                     (Task.attempt
                        (Struct.Event.attempted)
                        (Action.Scroll.to
                           (Struct.Character.get_location target_char)
                           model.ui
                        )
                     )
                  )

            (_, _) ->
               (
                  (ctrl_or_focus_character model target_char_id target_char),
                  (Task.attempt
                     (Struct.Event.attempted)
                     (Action.Scroll.to
                        (Struct.Character.get_location target_char)
                        model.ui
                     )
                  )
               )

      Nothing ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new
                  Struct.Error.Programming
                  "SelectCharacter: Unknown char selected."
               )
               model
            ),
            Cmd.none
         )

first_click_on : (
      Struct.Model.Type ->
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
first_click_on model target_char_id =
   if
   (
      (Struct.CharacterTurn.try_getting_target model.char_turn)
      ==
      (Just target_char_id)
   )
   then
      (model, Cmd.none)
   else
      case (Array.get target_char_id model.characters) of
         (Just target_char) ->
            (
               {model |
                  ui =
                     (Struct.UI.set_previous_action
                        (Just (Struct.UI.SelectedCharacter target_char_id))
                        (Struct.UI.set_displayed_tab
                           Struct.UI.StatusTab
                           (Struct.UI.set_displayed_nav
                              (get_character_navigator model target_char)
                              model.ui
                           )
                        )
                     )
               },
               Cmd.none
            )

         Nothing ->
            (
               (Struct.Model.invalidate
                  (Struct.Error.new
                     Struct.Error.Programming
                     "SelectCharacter: Unknown char selected."
                  )
                  model
               ),
               Cmd.none
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
   then
      (second_click_on model target_char_id)
   else
      (first_click_on model target_char_id)
