module Update.SetGlyphBoard exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.DataSet
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.GlyphBoard

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
      BattleCharacters.Struct.GlyphBoard.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model glyph_board_id =
   (
      (
         case model.edited_char of
            (Just char) ->
               let
                  base_char = (Struct.Character.get_base_character char)
                  updated_equipment =
                     (BattleCharacters.Struct.Equipment.set_glyph_board
                        (BattleCharacters.Struct.DataSet.get_glyph_board
                           glyph_board_id
                           model.characters_dataset
                        )
                        (BattleCharacters.Struct.Character.get_equipment
                           base_char
                        )
                     )
               in
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.update_glyph_family_index_collections
                           updated_equipment
                           (Struct.Character.set_base_character
                              (BattleCharacters.Struct.Character.set_equipment
                                 updated_equipment
                                 base_char
                              )
                              char
                           )
                        )
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
