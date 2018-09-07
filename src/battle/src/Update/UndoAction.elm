module Update.UndoAction exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

-- Battle ----------------------------------------------------------------------
import Struct.Map
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.Statistics
import Struct.Weapon
import Struct.WeaponSet

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
      weapon =
         (Struct.WeaponSet.get_active_weapon
            (Struct.Character.get_weapons char)
         )
   in
      (Struct.Navigator.new
         (Struct.Character.get_location char)
         (Struct.Statistics.get_movement_points
            (Struct.Character.get_statistics char)
         )
         (Struct.Weapon.get_defense_range weapon)
         (Struct.Weapon.get_attack_range weapon)
         (Struct.Map.get_movement_cost_function
            model.map
            (Struct.Character.get_location char)
            (Array.toList model.characters)
         )
      )

handle_reset_character_turn : Struct.Model.Type -> Struct.CharacterTurn.Type
handle_reset_character_turn model =
   case (Struct.CharacterTurn.try_getting_active_character model.char_turn) of
      Nothing -> model.char_turn

      (Just current_char) ->
         case
            (Array.get
               (Struct.Character.get_index current_char)
               model.characters
            )
         of
            Nothing -> model.char_turn

            (Just reset_char) ->
               (Struct.CharacterTurn.set_navigator
                  (get_character_navigator model reset_char)
                  (Struct.CharacterTurn.set_active_character
                     reset_char
                     (Struct.CharacterTurn.new)
                  )
               )

handle_undo_switched_weapons : Struct.Model.Type -> Struct.CharacterTurn.Type
handle_undo_switched_weapons model =
   case (Struct.CharacterTurn.try_getting_active_character model.char_turn) of
      Nothing -> model.char_turn

      (Just char) ->
         let
            new_weapons =
               (Struct.WeaponSet.switch_weapons
                  (Struct.Character.get_weapons char)
               )
            new_char =
               (Struct.Character.set_weapons new_weapons char)
            tile_omnimods = (Struct.Model.tile_omnimods_fun model)
         in
            (Struct.CharacterTurn.lock_path
               tile_omnimods
               (Struct.CharacterTurn.unlock_path
                  tile_omnimods
                  (Struct.CharacterTurn.set_has_switched_weapons
                     False
                     (Struct.CharacterTurn.set_active_character_no_reset
                        new_char
                        model.char_turn
                     )
                  )
               )
            )

handle_undo_chose_target : Struct.Model.Type -> Struct.CharacterTurn.Type
handle_undo_chose_target model =
   let
      tile_omnimods = (Struct.Model.tile_omnimods_fun model)
   in
      (Struct.CharacterTurn.lock_path
         (tile_omnimods)
         (Struct.CharacterTurn.unlock_path
            (tile_omnimods)
            (Struct.CharacterTurn.set_target Nothing model.char_turn)
         )
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (
      {model |
         char_turn =
         (
            case (Struct.CharacterTurn.get_state model.char_turn) of
               Struct.CharacterTurn.ChoseTarget ->
                  (handle_undo_chose_target model)

               Struct.CharacterTurn.SwitchedWeapons ->
                  (handle_undo_switched_weapons model)

               Struct.CharacterTurn.MovedCharacter ->
                  (handle_reset_character_turn model)

               _ -> model.char_turn
         )
      },
      Cmd.none
   )
