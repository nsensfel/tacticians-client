module Update.SwitchWeapon exposing (apply_to)
-- Elm -------------------------------------------------------------------------
import Array

-- Map -------------------------------------------------------------------
import Struct.Map
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.Statistics
import Struct.Weapon
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : Struct.Model.Type -> Struct.Model.Type
make_it_so model =
   case (Struct.CharacterTurn.try_getting_active_character model.char_turn) of
      (Just char) ->
         let
            new_weapons =
               (Struct.WeaponSet.switch_weapons
                  (Struct.Character.get_weapons char)
               )
            new_char = (Struct.Character.set_weapons new_weapons char)
         in
         {model |
            char_turn =
               (Struct.CharacterTurn.set_has_switched_weapons
                  True
                  (Struct.CharacterTurn.lock_path
                     (Struct.CharacterTurn.set_navigator
                        (Struct.Navigator.new
                           (Struct.Character.get_location new_char)
                           (Struct.Statistics.get_movement_points
                              (Struct.Character.get_statistics new_char)
                           )
                           (Struct.Weapon.get_attack_range
                              (Struct.WeaponSet.get_active_weapon new_weapons)
                           )
                           (Struct.Weapon.get_defense_range
                              (Struct.WeaponSet.get_active_weapon new_weapons)
                           )
                           (Struct.Map.get_movement_cost_function
                              model.map
                              (Struct.Character.get_location new_char)
                              (Array.toList model.characters)
                           )
                        )
                        (Struct.CharacterTurn.set_active_character
                           new_char
                           model.char_turn
                        )
                     )
                  )
               )
         }

      _ ->
         (Struct.Model.invalidate
            (Struct.Error.new
               Struct.Error.Programming
               (
                  "CharacterTurn structure in the 'SelectedCharacter' state"
                  ++ " without character being selected."
               )
            )
            model
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   case (Struct.CharacterTurn.get_state model.char_turn) of
      Struct.CharacterTurn.SelectedCharacter ->
         ((make_it_so model), Cmd.none)

      _ ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new
                  Struct.Error.Programming
                  (
                     "Attempt to switch weapons as a secondary action or"
                     ++ " without character being selected."
                  )
               )
               model
            ),
            Cmd.none
         )
