module View.Battlemap.Tile exposing (get_html)

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

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
noise_function : Int -> Int -> Int -> Int
noise_function a b c =
   (round
         (radians (toFloat ((a + 1) * 2 + (b + 1) * 3 + c)))
   )

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
               (
                  "battlemap-tile-variant-"
                  ++
                  (toString
                     -- I don't like how Elm does random, let's get some noisy
                     -- function instead.
                     (
                        (noise_function
                           tile_loc.x
                           tile_loc.y
                           (Struct.Tile.get_cost tile)
                        )
                        % 9
                     )
                  )
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
