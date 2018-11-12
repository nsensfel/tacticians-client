module Update.SetGlyph exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Roster Editor ---------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Glyph
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
      Struct.Glyph.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ref =
   (
      (
         case (model.edited_char, (Dict.get ref model.glyphs)) of
            ((Just char), (Just glyph)) ->
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.set_glyph
                           (Struct.UI.get_glyph_slot model.ui)
                           glyph
                           char
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
