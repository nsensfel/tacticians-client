module View.GlyphManagement exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Events

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Glyph
import Struct.GlyphBoard
import Struct.Omnimods
import Struct.Character
import Struct.Model

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
               (category ++ ": " ++ (toString value))
            )
         ]
      )

get_glyph_html : (
      Int ->
      (Int, Struct.Glyph.Type)
      -> (Html.Html Struct.Event.Type)
   )
get_glyph_html modifier (index, glyph) =
   (Html.div
      [
         (Html.Attributes.class "character-card-glyph"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick (Struct.Event.ClickedOnGlyph index))
      ]
      [
         (Html.text
            (
               (Struct.Glyph.get_name glyph)
               ++ " ("
               ++ (toString modifier)
               ++ "%)"
            )
         ),
         (Html.div
            [
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_all_mods
                  (Struct.Glyph.get_omnimods glyph)
               )
            )
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
         (Html.text "Glyph Management"),
         (case model.edited_char of
            Nothing -> (Html.div [] [(Html.text "No character selected")])
            (Just char) ->
               (Html.div
                  [
                     (Html.Attributes.class "selection-window-listing")
                  ]
                  (List.map2
                     (get_glyph_html)
                     (Struct.GlyphBoard.get_slots
                        (Struct.Character.get_glyph_board char)
                     )
                     (Array.toIndexedList (Struct.Character.get_glyphs char))
                  )
               )
         )
      ]
   )
