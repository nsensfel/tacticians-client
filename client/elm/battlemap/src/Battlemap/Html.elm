module Battlemap.Html exposing (view)

import Html exposing (Html, text, table, tr, td)
import Html.Events exposing (onClick)

-- import List as Lt exposing (map)
import Array as Ay exposing (foldr)

import Update exposing (Msg(..))
import Model exposing (Model)

import Battlemap exposing (Battlemap, random)
import Battlemap.Tile exposing (Tile)
import Battlemap.Direction exposing (Direction(..))

view_battlemap_cell : Tile -> (Html Msg)
view_battlemap_cell t =
   case t.char_level of
      Nothing ->
         (td
            []
            [
               (text "[_]"),
               (text
                  (
                     (case t.nav_level of
                        Right -> "R"
                        Left -> "L"
                        Up -> "U"
                        Down -> "D"
                        None -> (toString t.floor_level)
                     )
                  )
               )
            ]
         )
      (Just char_id) ->
         (td
            [ (onClick (SelectCharacter char_id)) ]
            [
               (text ("[" ++ char_id ++ "]")),
               (text
                  (
                     (case t.nav_level of
                        Right -> "R"
                        Left -> "L"
                        Up -> "U"
                        Down -> "D"
                        None -> (toString t.floor_level)
                     )
                  )
               )
            ]
         )

type alias GridBuilder =
   {
      row : (List (Html Msg)),
      columns : (List (Html Msg)),
      row_size : Int,
      bmap : Battlemap
   }

foldr_to_html : Tile -> GridBuilder -> GridBuilder
foldr_to_html t gb =
   if (gb.row_size == gb.bmap.width)
   then
      {gb |
         row = [(view_battlemap_cell t)],
         row_size = 1,
         columns =
            (
               (tr [] gb.row) :: gb.columns
            )
      }
   else
      {gb |
         row = ((view_battlemap_cell t) :: gb.row),
         row_size = (gb.row_size + 1)
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
   (view_battlemap m.battlemap)
