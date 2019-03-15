module View.Map.SelectableTile exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battle Map ------------------------------------------------------------------
import Struct.TileInstance
import Struct.Location

import View.Map.Tile

-- Map Editor ------------------------------------------------------------------
import Constants.UI
import Constants.IO

import Struct.Event
import Struct.Toolbox

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------

get_html : (
      Bool ->
      Struct.Toolbox.Type ->
      Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html display_cost tb tile =
   let
      tile_loc = (Struct.TileInstance.get_location tile)
   in
      (View.Map.Tile.get_html_with_extra
         display_cost
         [
            (
               if (Struct.Toolbox.is_selected tile_loc tb)
               then (Html.Attributes.class "tile-selected")
               else (Html.Attributes.class "")
            ),
            (
               if (Struct.Toolbox.is_square_corner tile_loc tb)
               then (Html.Attributes.class "tile-square-corner")
               else (Html.Attributes.class "")
            )
         ]
         tile
      )
