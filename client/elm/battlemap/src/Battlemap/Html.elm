module Battlemap.Html exposing (view)

import Array

import Html
import Html.Events

import Battlemap
import Battlemap.Tile
import Battlemap.Direction

import Update

type alias GridBuilder =
   {
      row : (List (Html.Html Update.Type)),
      columns : (List (Html.Html Update.Type)),
      row_size : Int,
      bmap : Battlemap.Type
   }

nav_level_to_text : Battlemap.Tile.Type -> String
nav_level_to_text t =
   case t.nav_level of
      Battlemap.Direction.Right -> "R"
      Battlemap.Direction.Left -> "L"
      Battlemap.Direction.Up -> "U"
      Battlemap.Direction.Down -> "D"
      Battlemap.Direction.None -> (toString t.floor_level)

view_battlemap_cell : Battlemap.Tile.Type -> (Html.Html Update.Type)
view_battlemap_cell t =
   case t.char_level of
      Nothing ->
         (Html.td
            []
            [
               (Html.text
                  (case t.mod_level of
                     Nothing -> "[_]"
                     (Just Battlemap.Tile.CanBeReached) -> "[M]"
                     (Just Battlemap.Tile.CanBeAttacked) -> "[A]"
                  )
               ),
               (Html.text (nav_level_to_text t))
            ]
         )
      (Just char_id) ->
         (Html.td
            [ (Html.Events.onClick (Update.SelectCharacter char_id)) ]
            [
               (Html.text ("[" ++ char_id ++ "]")),
               (Html.text (nav_level_to_text t))
            ]
         )


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
     ((Html.tr [] gb.row) :: gb.columns)

view : Battlemap.Type -> (Html.Html Update.Type)
view battlemap =
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
