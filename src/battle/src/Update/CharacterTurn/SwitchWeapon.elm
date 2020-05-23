module Update.CharacterTurn.SwitchWeapon exposing (apply_to)

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Weapon
import BattleCharacters.Struct.Character

-- Local module ----------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model

import Util.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   case (Struct.CharacterTurn.maybe_get_active_character model.char_turn) of
      (Just char) ->
         let
            new_base_character =
               (BattleCharacters.Struct.Character.switch_weapons
                  (Struct.Character.get_base_character char)
               )
            active_weapon =
               (BattleCharacters.Struct.Character.get_active_weapon
                  new_base_character
               )
            new_character =
               (Struct.Character.set_base_character
                  new_base_character
                  char
               )
         in
            (
               {model |
                  char_turn =
                     (Struct.CharacterTurn.set_action
                        Struct.CharacterTurn.SwitchingWeapons
                        (Struct.CharacterTurn.set_navigator
                           (Util.Navigator.get_character_attack_navigator
                              model.battle
                              new_character
                           )
                           (Struct.CharacterTurn.set_active_character
                              new_character
                              (Struct.CharacterTurn.store_path model.char_turn)
                           )
                        )
                     )
               },
               Cmd.none
            )

      Nothing -> (model, Cmd.none)
