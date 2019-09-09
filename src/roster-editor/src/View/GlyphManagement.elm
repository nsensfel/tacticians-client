module View.GlyphManagement exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Set

import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.View.Omnimods

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
      (Set.Set BattleCharacters.Struct.Glyph.Ref) ->
      Int ->
      (Int, BattleCharacters.Struct.Glyph.Type)
      -> (Html.Html Struct.Event.Type)
   )
get_glyph_html invalid_family_ids modifier (index, glyph) =
   (Html.div
      [
         (Html.Attributes.class "character-card-glyph"),
         (Html.Attributes.class "clickable"),
         (Html.Attributes.class
            (
               if
                  (Set.member
                     (BattleCharacters.Struct.Glyph.get_family_id glyph)
                     invalid_family_ids
                  )
               then "roster-editor-invalid-glyph"
               else "roster-editor-valid-glyph"
            )
         ),
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
                        (get_glyph_html
                           (Struct.Character.get_invalid_glyph_family_indices
                              char
                           )
                        )
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
