module View.GlyphManagement exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.GlyphBoard
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
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
               (category ++ ": " ++ (String.fromInt value))
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
               (BattleCharacters.Struct.Glyph.get_name glyph)
               ++ " ("
               ++ (String.fromInt modifier)
               ++ "%)"
            )
         ),
         (Html.div
            [
            ]
            (List.map
               (get_mod_html)
               (Battle.Struct.Omnimods.get_all_mods
                  (BattleCharacters.Struct.Glyph.get_omnimods glyph)
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
               let
                  equipment =
                     (BattleCharacters.Struct.Character.get_equipment
                        (Struct.Character.get_base_character char)
                     )
               in
                  (Html.div
                     [
                        (Html.Attributes.class "selection-window-listing")
                     ]
                     (List.map2
                        (get_glyph_html)
                        (BattleCharacters.Struct.GlyphBoard.get_slots
                           (BattleCharacters.Struct.Equipment.get_glyph_board
                              equipment
                           )
                        )
                        (Array.toIndexedList
                           (BattleCharacters.Struct.Equipment.get_glyphs
                              equipment
                           )
                        )
                     )
                  )
         )
      ]
   )
