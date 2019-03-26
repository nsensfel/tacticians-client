module Update.SetGlyphBoard exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
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
apply_to model ref =
   (
      (
         case (model.edited_char, (Dict.get ref model.glyph_boards)) of
            ((Just char), (Just glyph_board)) ->
               let base_char = (Struct.Character.get_base_character char) in
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.set_base_character
                           (BattleCharacters.Struct.Character.set_equipment
                              (BattleCharacters.Struct.Equipment.set_glyph_board
                                 glyph_board
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
