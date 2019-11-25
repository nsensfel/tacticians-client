module Update.SetWeapon exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.DataSet
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Weapon

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
equip : (
      BattleCharacters.Struct.Weapon.Type ->
      Struct.Character.Type ->
      Struct.Character.Type
   )
equip weapon char =
   let base_char = (Struct.Character.get_base_character char) in
      if (BattleCharacters.Struct.Character.is_using_secondary base_char) then
         (Struct.Character.set_base_character
            (BattleCharacters.Struct.Character.set_equipment
               (BattleCharacters.Struct.Equipment.set_secondary_weapon
                  weapon
                  (BattleCharacters.Struct.Character.get_equipment base_char)
               )
               base_char
            )
            char
         )
      else
         (Struct.Character.set_is_valid
            (Struct.Character.set_base_character
               (BattleCharacters.Struct.Character.set_equipment
                  (BattleCharacters.Struct.Equipment.set_primary_weapon
                     weapon
                     (BattleCharacters.Struct.Character.get_equipment base_char)
                  )
                  base_char
               )
               char
            )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      BattleCharacters.Struct.Weapon.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model weapon_id =
   (
      (
         case model.edited_char of
            (Just char) ->
               {model |
                  edited_char =
                     (Just
                        (equip
                           (BattleCharacters.Struct.DataSet.get_weapon
                              weapon_id
                              model.characters_dataset
                           )
                           char
                        )
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
