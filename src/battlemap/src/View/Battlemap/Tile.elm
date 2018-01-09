module View.Battlemap.Tile exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Constants.UI

import Struct.Event
import Struct.Location
import Struct.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Tile.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html tile =
   let
      tile_loc = (Struct.Tile.get_location tile)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-tile-icon"),
            (Html.Attributes.class "battlemap-tiled"),
            (Html.Attributes.class
               ("asset-tile-" ++ (Struct.Tile.get_icon_id tile))
            ),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick
               (Struct.Event.TileSelected (Struct.Location.get_ref tile_loc))
            )
--            ),
--            (Html.Attributes.style
--               [
--                  (
--                     "top",
--                     ((toString (tile_loc.y * Constants.UI.tile_size)) ++ "px")
--                  ),
--                  (
--                     "left",
--                     ((toString (tile_loc.x * Constants.UI.tile_size)) ++ "px")
--                  )
--               ]
--            )
         ]
         [
         ]
      )
