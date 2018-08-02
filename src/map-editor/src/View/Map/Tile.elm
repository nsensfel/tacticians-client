module View.Map.Tile exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Constants.UI
import Constants.IO

import Struct.Event
import Struct.Location
import Struct.Tile
import Struct.Toolbox

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Toolbox.Type ->
      Struct.Tile.Instance ->
      (Html.Html Struct.Event.Type)
   )
get_html tb tile =
   let
      tile_loc = (Struct.Tile.get_location tile)
   in
      (Html.div
         [
            (Html.Attributes.class "map-tile-icon"),
            (Html.Attributes.class "map-tiled"),
            (
               if (Struct.Toolbox.is_selected tile_loc tb)
               then (Html.Attributes.class "map-tile-selected")
               else (Html.Attributes.class "")
            ),
            (
               if (Struct.Toolbox.is_square_corner tile_loc tb)
               then (Html.Attributes.class "map-tile-square-corner")
               else (Html.Attributes.class "")
            ),
            (Html.Attributes.class
               (
                  "map-tile-variant-"
                  ++ (toString (Struct.Tile.get_local_variant_ix tile))
               )
            ),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick
               (Struct.Event.TileSelected (Struct.Location.get_ref tile_loc))
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
                  ),
                  (
                     "background-image",
                     (
                        "url("
                        ++ Constants.IO.tile_assets_url
                        ++ (Struct.Tile.get_icon_id tile)
                        ++".svg)"
                     )
                  )
               ]
            )
         ]
         [
         ]
      )
