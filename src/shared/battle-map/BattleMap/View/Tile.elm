module BattleMap.View.Tile exposing
   (
      get_html,
      get_html_with_extra,
      get_content_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

import Set

-- Battle Map ------------------------------------------------------------------
import Constants.UI
import Constants.IO

import BattleMap.Struct.Location
import BattleMap.Struct.TileInstance

-- Local -----------------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_layer_html : (
      Int ->
      BattleMap.Struct.TileInstance.Border ->
      (Html.Html Struct.Event.Type)
   )
get_layer_html index border =
   (Html.div
      [
         (Html.Attributes.class ("tile-icon-f-" ++ (String.fromInt index))),
         (Html.Attributes.style
            "background-image"
            (
               "url("
               ++ Constants.IO.tile_assets_url
               ++ (BattleMap.Struct.TileInstance.get_border_class_id border)
               ++ "-f-"
               ++ (BattleMap.Struct.TileInstance.get_border_variant_id border)
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
      BattleMap.Struct.TileInstance.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_content_html tile =
   (
      (Html.div
         [
            (Html.Attributes.class "tile-icon-dg")
         ]
         (
            case
               (Set.size
                  (BattleMap.Struct.TileInstance.get_triggers tile)
               )
            of
               0 -> []
               other -> [(Html.text (String.fromInt other))]
         )
      )
      ::
      (Html.div
         [
            (Html.Attributes.class "tile-icon-bg"),
            (Html.Attributes.style
               "background-image"
               (
                  "url("
                  ++ Constants.IO.tile_assets_url
                  ++ (BattleMap.Struct.TileInstance.get_class_id tile)
                  ++ "-bg.svg)"
               )
            )
         ]
         []
      )
      ::
      (Html.div
         [
            (Html.Attributes.class "tile-icon-bg"),
            (Html.Attributes.style
               "background-image"
               (
                  "url("
                  ++ Constants.IO.tile_assets_url
                  ++ (BattleMap.Struct.TileInstance.get_class_id tile)
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
               (Html.Attributes.class "tile-icon-dt"),
               (Html.Attributes.style
                  "background-image"
                  (
                     "url("
                     ++ Constants.IO.tile_assets_url
                     ++ (BattleMap.Struct.TileInstance.get_class_id tile)
                     ++ "-v-"
                     ++ (BattleMap.Struct.TileInstance.get_variant_id tile)
                     ++ ".svg)"
                  )
               )
            ]
            []
         )
         ::
         (List.indexedMap
            (get_layer_html)
            (BattleMap.Struct.TileInstance.get_borders tile)
         )
      )
   )

get_html : (
      Bool ->
      BattleMap.Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html display_cost tile =
   let tile_loc = (BattleMap.Struct.TileInstance.get_location tile) in
      (Html.div
         [
            (Html.Attributes.class "tile-icon"),
            (Html.Attributes.class "tiled"),
            (Html.Attributes.class
               (
                  "tile-variant-"
                  ++
                  (String.fromInt
                     (BattleMap.Struct.TileInstance.get_local_variant_ix tile)
                  )
               )
            ),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick
               (Struct.Event.TileSelected
                  (BattleMap.Struct.Location.get_ref tile_loc)
               )
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
         (
            if (display_cost)
            then
               (
                  (Html.div
                     [
                        (Html.Attributes.class "tile-icon-cost")
                     ]
                     [
                        (Html.text
                           (String.fromInt
                              (BattleMap.Struct.TileInstance.get_cost tile)
                           )
                        )
                     ]
                  )
                  :: (get_content_html tile)
               )
            else (get_content_html tile)
         )
      )

get_html_with_extra : (
      Bool ->
      (List (Html.Attribute Struct.Event.Type)) ->
      BattleMap.Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html_with_extra display_cost extra_classes tile =
   let tile_loc = (BattleMap.Struct.TileInstance.get_location tile) in
      (Html.div
         (
            extra_classes
            ++
            [
               (Html.Attributes.class "tile-icon"),
               (Html.Attributes.class "tiled"),
               (Html.Attributes.class
                  (
                     "tile-variant-"
                     ++
                     (String.fromInt
                        (BattleMap.Struct.TileInstance.get_local_variant_ix
                           tile
                        )
                     )
                  )
               ),
               (Html.Attributes.class "clickable"),
               (Html.Events.onClick
                  (Struct.Event.TileSelected
                     (BattleMap.Struct.Location.get_ref tile_loc)
                  )
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
         )
         (
            if (display_cost)
            then
               (
                  (Html.div
                     [
                        (Html.Attributes.class "tile-icon-cost")
                     ]
                     [
                        (Html.text
                           (String.fromInt
                              (BattleMap.Struct.TileInstance.get_cost tile)
                           )
                        )
                     ]
                  )
                  :: (get_content_html tile)
               )
            else (get_content_html tile)
         )
      )
