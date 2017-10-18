module Battlemap.Html exposing (view)

import Array

import Html
import Html.Events

import Battlemap
import Battlemap.Tile
import Battlemap.Direction

import Event

type alias GridBuilder =
   {
      row : (List (Html.Html Event.Type)),
      columns : (List (Html.Html Event.Type)),
      row_size : Int,
      bmap : Battlemap.Type
   }

view_battlemap_cell : Battlemap.Tile.Type -> (Html.Html Event.Type)
view_battlemap_cell t =
   (Html.td
      [
         (Html.Events.onClick
            (Battlemap.Tile.get_location t)
         ),
         (Html.Attribute.class (Battlemap.Tile.get_css_class t))
      ]
      [
         case (Battlemap.Tile.get_character t) of
            (Just char_id) ->
               (Character.Html.get_icon
                  (Character.get model char_id)
               )

            Nothing -> (Html.text "") -- Meaning no element.
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

grid_builder_to_html : GridBuilder -> (List (Html.Html Event.Type))
grid_builder_to_html gb =
   if (gb.row_size == 0)
   then
      gb.columns
   else
     ((Html.tr [] gb.row) :: gb.columns)

tiles_grid battlemap =
   (Html.table
      [
         (Html.Attribute.class "battlemap-tiles-grid")
      ]
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

view : Battlemap.Type -> (Html.Html Event.Type)
view battlemap =
   (Html.div
      [
         (Html.Attribute.class "battlemap-container")
      ]
      [
         (Html.div
            [
               (Html.Attribute.class "battlemap-tiles-container")
            ]
            [ (tiles_grid battlemap) ]
         ),
         case battlemap.navigator of
            (Just navigator) ->
               (Html.div
                  [
                     (Html.Attribute.class "battlemap-navigator-container")
                  ]
                  [ (Battlemap.Navigator.Html.view battlemap.navigator) ]
               )

            Nothing -> (Html.text "") -- Meaning no element.
      ]
   )
