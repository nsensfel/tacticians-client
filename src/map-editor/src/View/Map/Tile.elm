module View.Map.Tile exposing (get_html, get_content_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map Editor ------------------------------------------------------------------
import Constants.UI
import Constants.IO

import Struct.Event
import Struct.Location
import Struct.TileInstance
import Struct.Toolbox

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_layer_html : (
      Int ->
      Struct.TileInstance.Border ->
      (Html.Html Struct.Event.Type)
   )
get_layer_html index border =
   (Html.div
      [
         (Html.Attributes.class
            ("map-tile-icon-f-" ++ (String.fromInt index))
         ),
         (Html.Attributes.style
            "background-image"
            (
               "url("
               ++ Constants.IO.tile_assets_url
               ++ (Struct.TileInstance.get_border_class_id border)
               ++ "-f-"
               ++ (Struct.TileInstance.get_border_variant_id border)
               ++ ".svg)"
            )
         )
      ]
      []
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_content_html : (
      Struct.TileInstance.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_content_html tile =
   (
      (Html.div
         [
            (Html.Attributes.class "map-tile-icon-bg"),
            (Html.Attributes.style
               "background-image"
               (
                  "url("
                  ++ Constants.IO.tile_assets_url
                  ++ (Struct.TileInstance.get_class_id tile)
                  ++ "-bg.svg)"
               )
            )
         ]
         []
      )
      ::
      (
         (Html.div
            [
               (Html.Attributes.class "map-tile-icon-dt"),
               (Html.Attributes.style
                  "background-image"
                  (
                     "url("
                     ++ Constants.IO.tile_assets_url
                     ++ (Struct.TileInstance.get_class_id tile)
                     ++ "-v-"
                     ++ (Struct.TileInstance.get_variant_id tile)
                     ++ ".svg)"
                  )
               )
            ]
            []
         )
         ::
         (List.indexedMap
            (get_layer_html)
            (Struct.TileInstance.get_borders tile)
         )
      )
   )

get_html : (
      Struct.Toolbox.Type ->
      Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html tb tile =
   let
      tile_loc = (Struct.TileInstance.get_location tile)
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
                  ++
                  (String.fromInt
                     (Struct.TileInstance.get_local_variant_ix tile)
                  )
               )
            ),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick
               (Struct.Event.TileSelected (Struct.Location.get_ref tile_loc))
            ),
            (Html.Attributes.style
               "top"
               (
                  (String.fromInt (tile_loc.y * Constants.UI.tile_size))
                  ++ "px"
               )
            ),
            (Html.Attributes.style
               "left"
               (
                  (String.fromInt (tile_loc.x * Constants.UI.tile_size))
                  ++ "px"
               )
            )
         ]
         (get_content_html tile)
      )
