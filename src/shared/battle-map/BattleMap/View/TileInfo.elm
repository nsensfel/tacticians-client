module BattleMap.View.TileInfo exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

import Battle.View.Omnimods

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet
import BattleMap.Struct.Location
import BattleMap.Struct.Map
import BattleMap.Struct.Tile
import BattleMap.Struct.TileInstance

import BattleMap.View.Tile

-- Local Module ----------------------------------------------------------------
import Constants.Movement

import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon : (BattleMap.Struct.TileInstance.Type -> (Html.Html Struct.Event.Type))
get_icon tile_instance =
   (Html.div
      [
         (Html.Attributes.class "tile-card-icon"),
         (Html.Attributes.class "info-card-picture"),
         (Html.Attributes.class
            (
               "tile-variant-"
               ++
               (String.fromInt
                  (BattleMap.Struct.TileInstance.get_local_variant_ix
                     tile_instance
                  )
               )
            )
         )
      ]
      (BattleMap.View.Tile.get_content_html tile_instance)
   )

get_name : BattleMap.Struct.Tile.Type -> (Html.Html Struct.Event.Type)
get_name tile =
   (Html.div
      [
         (Html.Attributes.class "info-card-name"),
         (Html.Attributes.class "info-card-text-field"),
         (Html.Attributes.class "tile-card-name")
      ]
      [
         (Html.text
            (BattleMap.Struct.Tile.get_name tile)
         )
      ]
   )

get_cost : BattleMap.Struct.TileInstance.Type -> (Html.Html Struct.Event.Type)
get_cost tile_inst =
   let
      cost = (BattleMap.Struct.TileInstance.get_cost tile_inst)
      text =
         if (cost > Constants.Movement.max_points)
         then "Obstructed"
         else ("Cost: " ++ (String.fromInt cost))
   in
      (Html.div
         [
            (Html.Attributes.class "info-card-text-field"),
            (Html.Attributes.class "tile-card-cost")
         ]
         [
            (Html.text text)
         ]
      )

get_location : (
      BattleMap.Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_location tile_inst =
   let tile_location = (BattleMap.Struct.TileInstance.get_location tile_inst) in
      (Html.div
         [
            (Html.Attributes.class "info-card-text-field"),
            (Html.Attributes.class "tile-card-location")
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
      BattleMap.Struct.DataSet.Type ->
      BattleMap.Struct.Location.Ref ->
      BattleMap.Struct.Map.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html dataset loc_ref map =
   let loc = (BattleMap.Struct.Location.from_ref loc_ref) in
      case (BattleMap.Struct.Map.maybe_get_tile_at loc map) of
         (Just tile_instance) ->
            let
               tile_data =
                  (BattleMap.Struct.DataSet.get_tile
                     (BattleMap.Struct.TileInstance.get_class_id tile_instance)
                     dataset
                  )
            in
               (Html.div
                  [
                     (Html.Attributes.class "info-card"),
                     (Html.Attributes.class "tile-card")
                  ]
                  [
                     (get_name tile_data),
                     (Html.div
                        [
                           (Html.Attributes.class "info-card-top"),
                           (Html.Attributes.class "tile-card-top")
                        ]
                        [
                           (get_icon tile_instance),
                           (get_location tile_instance),
                           (get_cost tile_instance)
                        ]
                     ),
                     (Battle.View.Omnimods.get_signed_html
                        (BattleMap.Struct.Tile.get_omnimods tile_data)
                     )
                  ]
               )

         Nothing -> (Html.text "Error: Unknown tile location selected.")
