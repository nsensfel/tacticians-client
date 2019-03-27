module Update.SetArmor exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      BattleCharacters.Struct.Armor.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ref =
   (
      (
         case (model.edited_char, (Dict.get ref model.armors)) of
            ((Just char), (Just armor)) ->
               let base_char = (Struct.Character.get_base_character char) in
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.set_base_character
                           (BattleCharacters.Struct.Character.set_equipment
                              (BattleCharacters.Struct.Equipment.set_armor
                                 armor
                                 (BattleCharacters.Struct.Character.get_equipment
                                    base_char
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
