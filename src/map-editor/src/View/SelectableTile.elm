module View.SelectableTile exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.TileInstance
import BattleMap.Struct.Location

import BattleMap.View.Tile

-- Local Module ----------------------------------------------------------------
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
      BattleMap.Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html display_cost tb tile =
   let
      tile_loc = (BattleMap.Struct.TileInstance.get_location tile)
   in
      (BattleMap.View.Tile.get_html_with_extra
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
