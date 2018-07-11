module View.Map.Tile exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map -------------------------------------------------------------------
import Constants.UI
import Constants.IO

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
      Struct.Tile.Instance ->
      (Html.Html Struct.Event.Type)
   )
get_html tile =
   let
      tile_loc = (Struct.Tile.get_location tile)
   in
      (Html.div
         [
            (Html.Attributes.class "battle-tile-icon"),
            (Html.Attributes.class "battle-tiled"),
            (Html.Attributes.class
               (
                  "battle-tile-variant-"
                  ++ (toString (Struct.Tile.get_variant_id tile))
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
