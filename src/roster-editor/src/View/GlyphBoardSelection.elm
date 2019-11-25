module View.GlyphBoardSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Lazy
import Html.Attributes
import Html.Events

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.DataSet
import BattleCharacters.Struct.GlyphBoard

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_glyph_board_html : (
      BattleCharacters.Struct.GlyphBoard.Type ->
      (Html.Html Struct.Event.Type)
   )
get_glyph_board_html glyph_board =
   (Html.div
      [
         (Html.Attributes.class "character-card-glyph-board"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedGlyphBoard
               (BattleCharacters.Struct.GlyphBoard.get_id glyph_board)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "character-card-glyph-board-name")
            ]
            [
               (Html.text
                  (BattleCharacters.Struct.GlyphBoard.get_name glyph_board)
               )
            ]
         )
      ]
   )

true_get_html : (
      BattleCharacters.Struct.DataSet.Type ->
      (Html.Html Struct.Event.Type)
   )
true_get_html dataset =
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
            (List.map
               (get_glyph_board_html)
               (Dict.values
                  (BattleCharacters.Struct.DataSet.get_glyph_boards dataset)
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
   (Html.Lazy.lazy
      (true_get_html)
      model.characters_dataset
   )
