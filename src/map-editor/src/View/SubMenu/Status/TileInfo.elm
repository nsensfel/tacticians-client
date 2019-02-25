module View.SubMenu.Status.TileInfo exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Map Editor ------------------------------------------------------------------
import Constants.Movement

import Struct.Map
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.Tile
import Struct.TileInstance

import Util.Html

import View.Map.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon : (Struct.TileInstance.Type -> (Html.Html Struct.Event.Type))
get_icon tile =
   (Html.div
      [
         (Html.Attributes.class "map-tile-card-icon"),
         (Html.Attributes.class
            (
               "map-tile-variant-"
               ++
               (String.fromInt
                  (Struct.TileInstance.get_local_variant_ix tile)
               )
            )
         )
      ]
      (View.Map.Tile.get_content_html tile)
   )

get_name : (
      Struct.Model.Type ->
      Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_name model tile =
   case (Dict.get (Struct.TileInstance.get_class_id tile) model.tiles) of
      Nothing -> (Util.Html.nothing)
      (Just tile_type) ->
         (Html.div
            [
               (Html.Attributes.class "map-tile-card-name")
            ]
            [
               (Html.text (Struct.Tile.get_name tile_type))
            ]
         )

get_cost : (Struct.TileInstance.Type -> (Html.Html Struct.Event.Type))
get_cost tile =
   let
      cost = (Struct.TileInstance.get_cost tile)
      text =
         if (cost > Constants.Movement.max_points)
         then
            "Obstructed"
         else
            ("Cost: " ++ (String.fromInt cost))
   in
      (Html.div
         [
            (Html.Attributes.class "map-tile-card-cost")
         ]
         [
            (Html.text text)
         ]
      )

get_location : (Struct.TileInstance.Type -> (Html.Html Struct.Event.Type))
get_location tile =
   let
      tile_location = (Struct.TileInstance.get_location tile)
   in
      (Html.div
         [
            (Html.Attributes.class "map-tile-card-location")
         ]
         [
            (Html.text
               (
                  "{x: "
                  ++ (String.fromInt tile_location.x)
                  ++ "; y: "
                  ++ (String.fromInt tile_location.y)
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
   case (Struct.Map.try_getting_tile_at loc model.map) of
      (Just tile) ->
         (Html.div
            [
               (Html.Attributes.class "map-tile-card")
            ]
            [
               (get_name model tile),
               (Html.div
                  [
                     (Html.Attributes.class "map-tile-card-top")
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
