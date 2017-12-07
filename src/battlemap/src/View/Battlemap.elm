module View.Battlemap exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

import List

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Event
import Struct.Model
import Struct.Tile
import Struct.UI

import View.Battlemap.Character
import View.Battlemap.Navigator
import View.Battlemap.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_tiles_line_html : (
      (List (Html.Html Struct.Event.Type)) ->
      (Html.Html Struct.Event.Type)
   )
get_tiles_line_html tiles_list =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tiles-layer-row")
      ]
      tiles_list
   )

get_tiles_lines_html : (
      Int ->
      Struct.Tile.Type ->
      (
         Int,
         (List (Html.Html Struct.Event.Type)),
         (List (Html.Html Struct.Event.Type))
      ) ->
      (
         Int,
         (List (Html.Html Struct.Event.Type)),
         (List (Html.Html Struct.Event.Type))
      )
   )
get_tiles_lines_html max_index tile (curr_index, curr_line, result) =
   if (curr_index == 0)
   then
      (
         max_index,
         [],
         (
            (get_tiles_line_html
               ((View.Battlemap.Tile.get_html tile) :: curr_line)
            )
            ::
            result
         )
      )
   else
      (
         (curr_index - 1),
         ((View.Battlemap.Tile.get_html tile) :: curr_line),
         result
      )

get_tiles_html : Struct.Battlemap.Type -> (Html.Html Struct.Event.Type)
get_tiles_html battlemap =
   let
      bmap_width = (Struct.Battlemap.get_width battlemap)
      max_index = (bmap_width - 1)
      (_, last_line, other_lines) =
         (Array.foldr
            (get_tiles_lines_html max_index)
            (max_index, [], [])
            (Struct.Battlemap.get_tiles battlemap)
         )
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-tiles-layer")
         ]
         ((get_tiles_line_html last_line) :: other_lines)
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-actual"),
         (Html.Attributes.style
            [
               (
                  "transform",
                  (
                     "scale("
                     ++
                     (toString (Struct.UI.get_zoom_level model))
                     ++ ")"
                  )
               )
            ]
         )
      ]
      (
         (Html.Lazy.lazy (get_tiles_html) model.battlemap)
         ::
         (List.map
            (View.Battlemap.Character.get_html)
            model.characters
         )
      )
   )
