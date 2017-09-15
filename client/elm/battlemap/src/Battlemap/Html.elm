module Battlemap.Html exposing (view)

import Html exposing (Html, text, table, tr, td)
-- import List as Lt exposing (map)
import Array as Ay exposing (foldr)

import Update exposing (Msg)
import Model exposing (Model)

import Battlemap exposing (Battlemap, random)
import Battlemap.Tile exposing (Tile)

view_battlemap_cell : Tile -> (Html Msg)
view_battlemap_cell t =
   (td
      []
      [ (text (toString t.floor_level)) ]
   )

type alias GridBuilder =
   {
      row : (List (Html Msg)),
      columns : (List (Html Msg)),
      row_size : Int,
      bmap : Battlemap
   }

foldr_to_html : Tile -> GridBuilder -> GridBuilder
foldr_to_html t bg =
   if (bg.row_size == bg.bmap.width)
   then
      {bg |
         row = [(view_battlemap_cell t)],
         row_size = 1,
         columns =
            (
               (tr [] bg.row) :: bg.columns
            )
      }
   else
      {bg |
         row = ((view_battlemap_cell t) :: bg.row),
         row_size = (bg.row_size + 1)
      }

grid_builder_to_html : GridBuilder -> (List (Html Msg))
grid_builder_to_html gb =
   if (gb.row_size == 0)
   then
      gb.columns
   else
      (grid_builder_to_html
         {gb |
            row = [],
            row_size = 0,
            columns =
               (
                  (tr [] gb.row) :: gb.columns
               )
         }
      )

view_battlemap : Battlemap -> (Html Msg)
view_battlemap battlemap =
   (table
      []
      (grid_builder_to_html
         (Ay.foldr
            (foldr_to_html)
            {
               row = [],
               columns = [],
               row_size = 0,
               bmap = battlemap
            }
            battlemap.content
         )
      )
   )


view : Model -> (Html Msg)
view m =
   (view_battlemap random)
