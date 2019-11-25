module Update.SetPortrait exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.DataSet
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Portrait

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
      BattleCharacters.Struct.Portrait.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model portrait_id =
   (
      (
         case model.edited_char of
            (Just char) ->
               let base_char = (Struct.Character.get_base_character char) in
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.set_base_character
                           (BattleCharacters.Struct.Character.set_equipment
                              (BattleCharacters.Struct.Equipment.set_portrait
                                 (BattleCharacters.Struct.DataSet.get_portrait
                                    portrait_id
                                    model.characters_dataset
                                 )
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
