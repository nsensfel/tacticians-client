module Battlemap.Html exposing (view)

import Array

import Html
import Html.Events

import Battlemap
import Battlemap.Tile
import Battlemap.Direction

import Update
import Model

view_battlemap_cell : Battlemap.Tile.Type -> (Html.Html Update.Type)
view_battlemap_cell t =
   case t.char_level of
      Nothing ->
         (Html.td
            []
            [
               (Html.text "[_]"),
               (Html.text
                  (
                     (case t.nav_level of
                        Battlemap.Direction.Right -> "R"
                        Battlemap.Direction.Left -> "L"
                        Battlemap.Direction.Up -> "U"
                        Battlemap.Direction.Down -> "D"
                        Battlemap.Direction.None -> (toString t.floor_level)
                     )
                  )
               )
            ]
         )
      (Just char_id) ->
         (Html.td
            [ (Html.Events.onClick (Update.SelectCharacter char_id)) ]
            [
               (Html.text ("[" ++ char_id ++ "]")),
               (Html.text
                  (
                     (case t.nav_level of
                        Battlemap.Direction.Right -> "R"
                        Battlemap.Direction.Left -> "L"
                        Battlemap.Direction.Up -> "U"
                        Battlemap.Direction.Down -> "D"
                        Battlemap.Direction.None -> (toString t.floor_level)
                     )
                  )
               )
            ]
         )

type alias GridBuilder =
   {
      row : (List (Html.Html Update.Type)),
      columns : (List (Html.Html Update.Type)),
      row_size : Int,
      bmap : Battlemap.Type
   }

foldr_to_html : Battlemap.Tile.Type -> GridBuilder -> GridBuilder
foldr_to_html t gb =
   if (gb.row_size == gb.bmap.width)
   then
      {gb |
         row = [(view_battlemap_cell t)],
         row_size = 1,
         columns =
            (
               (Html.tr [] gb.row) :: gb.columns
            )
      }
   else
      {gb |
         row = ((view_battlemap_cell t) :: gb.row),
         row_size = (gb.row_size + 1)
      }

grid_builder_to_html : GridBuilder -> (List (Html.Html Update.Type))
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
                  (Html.tr [] gb.row) :: gb.columns
               )
         }
      )

view_battlemap : Battlemap.Type -> (Html.Html Update.Type)
view_battlemap battlemap =
   (Html.table
      []
      (grid_builder_to_html
         (Array.foldr
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


view : Model.Type -> (Html.Html Update.Type)
view m =
   (view_battlemap m.battlemap)
