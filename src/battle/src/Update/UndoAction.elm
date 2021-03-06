module Update.UndoAction exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.Navigator

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
         (Battle.Struct.Attributes.get_movement_points
            (BattleCharacters.Struct.Character.get_attributes base_char)
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
         (Struct.CharacterTurn.lock_path
            (Struct.CharacterTurn.unlock_path
               (Struct.CharacterTurn.set_has_switched_weapons
                  False
                  (Struct.CharacterTurn.set_active_character_no_reset
                     (Struct.Character.set_base_character
                        (BattleCharacters.Struct.Character.switch_weapons
                           (Struct.Character.get_base_character char)
                        )
                        char
                     )
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
         (Struct.CharacterTurn.unlock_path
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
