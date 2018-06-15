module View.SubMenu.Status.TileInfo exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Struct.Battlemap -------------------------------------------------------------------
import Constants.IO
import Constants.Movement

import Struct.Battlemap
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon : (Struct.Tile.Type -> (Html.Html Struct.Event.Type))
get_icon tile =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tile-card-icon"),
         (Html.Attributes.class
            (
               "battlemap-tile-variant-"
               ++ (toString (Struct.Tile.get_variant_id tile))
            )
         ),
         (Html.Attributes.style
            [
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

get_name : (Struct.Tile.Type -> (Html.Html Struct.Event.Type))
get_name tile =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tile-card-name")
      ]
      [
         (Html.text
            (
               "Tile Type "
               ++ (Struct.Tile.get_icon_id tile)
            )
         )
      ]
   )

get_cost : (Struct.Tile.Type -> (Html.Html Struct.Event.Type))
get_cost tile =
   let
      cost = (Struct.Tile.get_cost tile)
      text =
         if (cost > Constants.Movement.max_points)
         then
            "Obstructed"
         else
            ("Cost: " ++ (toString cost))
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-tile-card-cost")
         ]
         [
            (Html.text text)
         ]
      )

get_location : (Struct.Tile.Type -> (Html.Html Struct.Event.Type))
get_location tile =
   let
      tile_location = (Struct.Tile.get_location tile)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-tile-card-location")
         ]
         [
            (Html.text
               (
                  "{x: "
                  ++ (toString tile_location.x)
                  ++ "; y: "
                  ++ (toString tile_location.y)
                  ++ "}"
               )
            )
         ]
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.Location.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model loc =
   case (Struct.Battlemap.try_getting_tile_at loc model.battlemap) of
      (Just tile) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-tile-card")
            ]
            [
               (get_name tile),
               (Html.div
                  [
                     (Html.Attributes.class "battlemap-tile-card-top")
                  ]
                  [
                     (get_icon tile),
                     (get_location tile),
                     (get_cost tile)
                  ]
               )
            ]
         )

      Nothing -> (Html.text "Error: Unknown tile location selected.")
