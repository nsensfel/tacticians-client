module Update.SetGlyphBoard exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Roster Editor ---------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.GlyphBoard
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.GlyphBoard.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ref =
   (
      (
         case (model.edited_char, (Dict.get ref model.glyph_boards)) of
            ((Just char), (Just glyph_board)) ->
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.set_glyph_board glyph_board char)
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
