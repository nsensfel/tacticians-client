module View.GlyphSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.View.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Glyph

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_mod_html : (String, Int) -> (Html.Html Struct.Event.Type)
get_mod_html mod =
   let (category, value) = mod in
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

get_glyph_html : (
      BattleCharacters.Struct.Glyph.Type ->
      (Html.Html Struct.Event.Type)
   )
get_glyph_html glyph  =
   (Html.div
      [
         (Html.Attributes.class "character-card-glyph"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedGlyph
               (BattleCharacters.Struct.Glyph.get_id glyph)
            )
         )
      ]
      [
         (Html.text (BattleCharacters.Struct.Glyph.get_name glyph)),
         (Battle.View.Omnimods.get_html
            (BattleCharacters.Struct.Glyph.get_omnimods glyph)
         )
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
