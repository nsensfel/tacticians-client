module Update.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

import Task

-- Battlemap -------------------------------------------------------------------
import Action.Scroll

import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.Navigator
import Struct.Statistics
import Struct.UI
import Struct.Weapon
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
attack_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
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
         (Struct.UI.reset_displayed_tab
            (Struct.UI.set_previous_action Nothing model.ui)
         )
   }

ctrl_or_focus_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
ctrl_or_focus_character model target_char_id target_char =
   if (Struct.Character.is_enabled target_char)
   then
      let
         weapon =
            (Struct.WeaponSet.get_active_weapon
               (Struct.Character.get_weapons target_char)
            )
      in
         {model |
            char_turn =
               (Struct.CharacterTurn.set_navigator
                  (Struct.Navigator.new
                     (Struct.Character.get_location target_char)
                     (Struct.Statistics.get_movement_points
                        (Struct.Character.get_statistics target_char)
                     )
                     (Struct.Weapon.get_attack_range weapon)
                     (Struct.Weapon.get_defense_range weapon)
                     (Struct.Battlemap.get_movement_cost_function
                        model.battlemap
                        (Struct.Character.get_location target_char)
                        (Dict.values model.characters)
                     )
                  )
                  (Struct.CharacterTurn.set_active_character
                     target_char
                     model.char_turn
                  )
               ),
            ui =
               (Struct.UI.reset_displayed_tab
                  (Struct.UI.set_previous_action Nothing model.ui)
               )
         }
   else
      {model |
         ui =
            (Struct.UI.set_previous_action
               (Just (Struct.UI.SelectedCharacter target_char_id))
               model.ui
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
                     (Struct.Location.get_ref
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

double_clicked_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
double_clicked_character model target_char_id =
   case (Dict.get target_char_id model.characters) of
      (Just target_char) ->
         case
            (Struct.CharacterTurn.try_getting_active_character
               model.char_turn
            )
         of
            (Just _) ->
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

            _ ->
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
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
      (double_clicked_character model target_char_id)
   else
      (
         {model |
            ui =
               (Struct.UI.set_previous_action
                  (Just (Struct.UI.SelectedCharacter target_char_id))
                  (Struct.UI.set_displayed_tab
                     Struct.UI.StatusTab
                     model.ui
                  )
               )
         },
         Cmd.none
      )
