module View.GlyphSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Glyph
import Struct.Omnimods
import Struct.Model

import View.Omnimods

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_mod_html : (String, Int) -> (Html.Html Struct.Event.Type)
get_mod_html mod =
   let
      (category, value) = mod
   in
      (Html.div
         [
            (Html.Attributes.class "info-card-mod")
         ]
         [
            (Html.text
               (category ++ ": " ++ (String.fromInt value))
            )
         ]
      )

get_glyph_html : Struct.Glyph.Type -> (Html.Html Struct.Event.Type)
get_glyph_html glyph  =
   (Html.div
      [
         (Html.Attributes.class "character-card-glyph"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedGlyph
               (Struct.Glyph.get_id glyph)
            )
         )
      ]
      [
         (Html.text (Struct.Glyph.get_name glyph)),
         (View.Omnimods.get_html 1.0 (Struct.Glyph.get_omnimods glyph))
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "selection-window"),
         (Html.Attributes.class "glyph-management")
      ]
      [
         (Html.text "Glyph Selection"),
         (Html.div
            [
               (Html.Attributes.class "selection-window-listing")
            ]
            (List.map
               (get_glyph_html)
               (Dict.values model.glyphs)
            )
         )
      ]
   )
