module Update.SetGlyph exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.DataSet
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Glyph

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
      BattleCharacters.Struct.Glyph.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model glyph_id =
   (
      (
         case model.edited_char of
            (Just char) ->
               let
                  base_char = (Struct.Character.get_base_character char)
                  (glyph_slot, glyph_modifier) =
                        (Struct.UI.get_glyph_slot model.ui)
                  updated_equipment =
                     (BattleCharacters.Struct.Equipment.set_glyph
                        glyph_slot
                        (BattleCharacters.Struct.DataSet.get_glyph
                           glyph_id
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
                     ),
                  ui =
                     (Struct.UI.set_displayed_tab
                        Struct.UI.GlyphManagementTab
                        model.ui
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
