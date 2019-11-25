module View.SubMenu.TileStatus exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Battle ----------------------------------------------------------------------
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
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon : (BattleMap.Struct.TileInstance.Type -> (Html.Html Struct.Event.Type))
get_icon tile =
   (Html.div
      [
         (Html.Attributes.class "tile-card-icon"),
         (Html.Attributes.class "info-card-picture"),
         (Html.Attributes.class
            (
               "tile-variant-"
               ++
               (String.fromInt
                  (BattleMap.Struct.TileInstance.get_local_variant_ix tile)
               )
            )
         )
      ]
      (BattleMap.View.Tile.get_content_html tile)
   )

get_name : (
      BattleMap.Struct.DataSet.Type ->
      BattleMap.Struct.TileInstance.Type ->
      (Html.Html Struct.Event.Type)
   )
get_name dataset tile_inst =
   (Html.div
      [
         (Html.Attributes.class "info-card-name"),
         (Html.Attributes.class "info-card-text-field"),
         (Html.Attributes.class "tile-card-name")
      ]
      [
         (Html.text
            (BattleMap.Struct.Tile.get_name
               (BattleMap.Struct.DataSet.get_tile
                  (BattleMap.Struct.TileInstance.get_class_id tile_inst)
                  dataset
               )
            )
         )
      ]
   )

get_cost : BattleMap.Struct.TileInstance.Type -> (Html.Html Struct.Event.Type)
get_cost tile_inst =
   let
      cost = (BattleMap.Struct.TileInstance.get_cost tile_inst)
      text =
         if (cost > Constants.Movement.max_points)
         then
            "Obstructed"
         else
            ("Cost: " ++ (String.fromInt cost))
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
   let
      tile_location = (BattleMap.Struct.TileInstance.get_location tile_inst)
   in
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

get_tile_info_html : (
      Struct.Model.Type ->
      BattleMap.Struct.Location.Type ->
      (Html.Html Struct.Event.Type)
   )
get_tile_info_html model loc =
   case (BattleMap.Struct.Map.try_getting_tile_at loc model.map) of
      (Just tile) ->
         (Html.div
            [
               (Html.Attributes.class "info-card"),
               (Html.Attributes.class "tile-card")
            ]
            [
               (get_name model.map_dataset tile),
               (Html.div
                  [
                     (Html.Attributes.class "info-card-top"),
                     (Html.Attributes.class "tile-card-top")
                  ]
                  [
                     (get_icon tile),
                     (get_location tile),
                     (get_cost tile)
                  ]
               ),
               (Battle.View.Omnimods.get_signed_html
                  (BattleMap.Struct.Map.get_omnimods_at
                     loc
                     model.map_dataset
                     model.map
                  )
               )
            ]
         )

      Nothing -> (Html.text "Error: Unknown tile location selected.")

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "tabmenu-content"),
         (Html.Attributes.class "tabmenu-content-status")
      ]
      [
         (case (Struct.UI.get_previous_action model.ui) of
            (Just (Struct.UI.SelectedLocation loc)) ->
               (get_tile_info_html
                  model
                  (BattleMap.Struct.Location.from_ref loc)
               )

            _ ->
               (Html.text "Nothing is being focused.")
         )
      ]
   )
