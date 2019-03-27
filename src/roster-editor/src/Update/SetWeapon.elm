module Update.SetWeapon exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      BattleCharacters.Struct.Weapon.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ref =
   (
      (
         case (model.edited_char, (Dict.get ref model.weapons)) of
            ((Just char), (Just weapon)) ->
               {model |
                  edited_char =
                     let
                        base_char = (Struct.Character.get_base_character char)
                     in
                     (Just
                        (Struct.Character.set_base_character
                           (BattleCharacters.Struct.Character.set_equipment
                              (
                                 if
                                    (BattleCharacters.Struct.Character.is_using_secondary
                                       base_char
                                    )
                                 then
                                    (BattleCharacters.Struct.Equipment.set_secondary_weapon
                                       weapon
                                       (BattleCharacters.Struct.Character.get_equipment
                                          base_char
                                       )
                                    )
                                 else
                                    (BattleCharacters.Struct.Equipment.set_primary_weapon
                                       weapon
                                       (BattleCharacters.Struct.Character.get_equipment
                                          base_char
                                       )
                                    )
                              )
                              base_char
                           )
                           char
                        )
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
