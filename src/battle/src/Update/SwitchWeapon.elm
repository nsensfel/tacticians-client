module Update.SwitchWeapon exposing (apply_to)

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Weapon
import BattleCharacters.Struct.Character

-- Local module ----------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : Struct.Model.Type -> Struct.Model.Type
make_it_so model =
   case
      (
         (Struct.CharacterTurn.try_getting_active_character model.char_turn),
         (Struct.CharacterTurn.try_getting_navigator model.char_turn)
      )
   of
      ((Just char), (Just nav)) ->
         let
            new_base_character =
               (BattleCharacters.Struct.Character.switch_weapons
                  (Struct.Character.get_base_character char)
               )
            active_weapon =
               (BattleCharacters.Struct.Character.get_active_weapon
                  new_base_character
               )
         in
            {model |
               char_turn =
                  (Struct.CharacterTurn.show_attack_range_navigator
                     (BattleCharacters.Struct.Weapon.get_defense_range
                        active_weapon
                     )
                     (BattleCharacters.Struct.Weapon.get_attack_range
                        active_weapon
                     )
                     (Struct.CharacterTurn.set_has_switched_weapons
                        True
                        (Struct.CharacterTurn.set_active_character_no_reset
                           (Struct.Character.set_base_character
                              new_base_character
                              char
                           )
                           model.char_turn
                        )
                     )
                  )
            }

      (_, _) ->
         (Struct.Model.invalidate
            (Struct.Error.new
               Struct.Error.Programming
               """
               CharacterTurn structure in the 'SelectedCharacter' or
               'MovedCharacter' state without any character being selected.
               """)
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

      Struct.CharacterTurn.MovedCharacter ->
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
