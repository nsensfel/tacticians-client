module View.Battlemap.Tile exposing (get_html)

import Html
import Html.Attributes
import Html.Events

import Battlemap.Tile
import Battlemap.Location

import Constants.UI

import Event

get_html : (
      Battlemap.Tile.Type ->
      (Html.Html Event.Type)
   )
get_html tile =
   let
      tile_loc = (Battlemap.Tile.get_location tile)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-tile-icon"),
            (Html.Attributes.class "battlemap-tiled"),
            (Html.Attributes.class
               ("asset-tile-" ++ (Battlemap.Tile.get_icon_id tile))
            ),
            (Html.Events.onClick
               (Event.TileSelected (Battlemap.Location.get_ref tile_loc))
            ),
            (Html.Attributes.style
               [
                  (
                     "top",
                     ((toString (tile_loc.y * Constants.UI.tile_size)) ++ "px")
                  ),
                  (
                     "left",
                     ((toString (tile_loc.x * Constants.UI.tile_size)) ++ "px")
                  )
               ]
            )
         ]
         [
         ]
      )
