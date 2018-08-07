module View.SubMenu.Status.TileInfo exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Struct.Map -------------------------------------------------------------------
import Constants.Movement

import Struct.Map
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.Tile

import Util.Html

import View.Map.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon : (Struct.Tile.Instance -> (Html.Html Struct.Event.Type))
get_icon tile =
   (Html.div
      [
         (Html.Attributes.class "battle-tile-card-icon"),
         (Html.Attributes.class "battle-info-card-picture"),
         (Html.Attributes.class
            (
               "battle-tile-variant-"
               ++ (toString (Struct.Tile.get_local_variant_ix tile))
            )
         )
      ]
      (View.Map.Tile.get_content_html tile)
   )

get_name : (
      Struct.Model.Type ->
      Struct.Tile.Instance ->
      (Html.Html Struct.Event.Type)
   )
get_name model tile =
   case (Dict.get (Struct.Tile.get_type_id tile) model.tiles) of
      Nothing -> (Util.Html.nothing)
      (Just tile_type) ->
         (Html.div
            [
               (Html.Attributes.class "battle-info-card-name"),
               (Html.Attributes.class "battle-info-card-text-field"),
               (Html.Attributes.class "battle-tile-card-name")
            ]
            [
               (Html.text (Struct.Tile.get_name tile_type))
            ]
         )

get_cost : (Struct.Tile.Instance -> (Html.Html Struct.Event.Type))
get_cost tile =
   let
      cost = (Struct.Tile.get_instance_cost tile)
      text =
         if (cost > Constants.Movement.max_points)
         then
            "Obstructed"
         else
            ("Cost: " ++ (toString cost))
   in
      (Html.div
         [
            (Html.Attributes.class "battle-info-card-text-field"),
            (Html.Attributes.class "battle-tile-card-cost")
         ]
         [
            (Html.text text)
         ]
      )

get_location : (Struct.Tile.Instance -> (Html.Html Struct.Event.Type))
get_location tile =
   let
      tile_location = (Struct.Tile.get_location tile)
   in
      (Html.div
         [
            (Html.Attributes.class "battle-info-card-text-field"),
            (Html.Attributes.class "battle-tile-card-location")
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
   case (Struct.Map.try_getting_tile_at loc model.map) of
      (Just tile) ->
         (Html.div
            [
               (Html.Attributes.class "battle-info-card"),
               (Html.Attributes.class "battle-tile-card")
            ]
            [
               (get_name model tile),
               (Html.div
                  [
                     (Html.Attributes.class "battle-info-card-top"),
                     (Html.Attributes.class "battle-tile-card-top")
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
