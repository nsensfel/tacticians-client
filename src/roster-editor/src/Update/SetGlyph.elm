module Update.SetGlyph exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Roster Editor ---------------------------------------------------------------
import Struct.Character
import Struct.Error
import Struct.Event
import Struct.Glyph
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Glyph.Ref ->
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ref index =
   (
      (
         case (model.edited_char, (Dict.get ref model.glyphs)) of
            ((Just char), (Just glyph)) ->
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.set_glyph index glyph char)
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
