module View.Map.Tile exposing (get_html, get_content_html)

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
get_layer_html : (
      Int ->
      Struct.Tile.Border ->
      (Html.Html Struct.Event.Type)
   )
get_layer_html index border =
   (Html.div
      [
         (Html.Attributes.class ("tile-icon-f-" ++ (toString index))),
         (Html.Attributes.style
            [
               (
                  "background-image",
                  (
                     "url("
                     ++ Constants.IO.tile_assets_url
                     ++ (Struct.Tile.get_border_type_id border)
                     ++ "-f-"
                     ++ (Struct.Tile.get_border_variant_id border)
                     ++ ".svg)"
                  )
               )
            ]
         )
      ]
      []
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_content_html : Struct.Tile.Instance -> (List (Html.Html Struct.Event.Type))
get_content_html tile =
   (
      (Html.div
         [
            (Html.Attributes.class "tile-icon-bg"),
            (Html.Attributes.style
               [
                  (
                     "background-image",
                     (
                        "url("
                        ++ Constants.IO.tile_assets_url
                        ++ (Struct.Tile.get_type_id tile)
                        ++ "-bg.svg)"
                     )
                  )
               ]
            )
         ]
         []
      )
      ::
      (
         (Html.div
            [
               (Html.Attributes.class "tile-icon-dt"),
               (Html.Attributes.style
                  [
                     (
                        "background-image",
                        (
                           "url("
                           ++ Constants.IO.tile_assets_url
                           ++ (Struct.Tile.get_type_id tile)
                           ++ "-v-"
                           ++ (Struct.Tile.get_variant_id tile)
                           ++ ".svg)"
                        )
                     )
                  ]
               )
            ]
            []
         )
         ::
         (List.indexedMap
            (get_layer_html)
            (Struct.Tile.get_borders tile)
         )
      )
   )

get_html : Struct.Tile.Instance -> (Html.Html Struct.Event.Type)
get_html tile =
   let tile_loc = (Struct.Tile.get_location tile) in
      (Html.div
         [
            (Html.Attributes.class "tile-icon"),
            (Html.Attributes.class "tiled"),
            (Html.Attributes.class
               (
                  "tile-variant-"
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
                  )
               ]
            )
         ]
         (get_content_html tile)
      )
