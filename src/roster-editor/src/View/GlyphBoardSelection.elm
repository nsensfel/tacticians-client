module View.GlyphBoardSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Roster Editor ---------------------------------------------------------------
import Struct.GlyphBoard
import Struct.Event
import Struct.Model
import Struct.Omnimods

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

get_glyph_board_html : Struct.GlyphBoard.Type -> (Html.Html Struct.Event.Type)
get_glyph_board_html glyph_board =
   (Html.div
      [
         (Html.Attributes.class "character-card-glyph-board"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedGlyphBoard
               (Struct.GlyphBoard.get_id glyph_board)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "character-card-glyph-board-name")
            ]
            [
               (Html.text (Struct.GlyphBoard.get_name glyph_board))
            ]
         ),
         (View.Omnimods.get_html (Struct.GlyphBoard.get_omnimods glyph_board))
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
         (Html.Attributes.class "glyph-board-selection")
      ]
      [
         (Html.text "Glyph Board Selection"),
         (Html.div
            [
               (Html.Attributes.class "selection-window-listing")
            ]
            (List.map (get_glyph_board_html) (Dict.values model.glyph_boards))
         )
      ]
   )
