module View.SubMenu.Status.TileInfo exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battle ----------------------------------------------------------------------
import Constants.Movement

import Struct.Map
import Struct.Event
import Struct.Location
import Struct.Omnimods
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
         (Html.Attributes.class "tile-card-icon"),
         (Html.Attributes.class "info-card-picture"),
         (Html.Attributes.class
            (
               "tile-variant-"
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
get_name model tile_inst =
   case (Dict.get (Struct.TileInstance.get_class_id tile_inst) model.tiles) of
      Nothing -> (Util.Html.nothing)
      (Just tile) ->
         (Html.div
            [
               (Html.Attributes.class "info-card-name"),
               (Html.Attributes.class "info-card-text-field"),
               (Html.Attributes.class "tile-card-name")
            ]
            [
               (Html.text (Struct.Tile.get_name tile))
            ]
         )

get_cost : Struct.TileInstance.Type -> (Html.Html Struct.Event.Type)
get_cost tile_inst =
   let
      cost = (Struct.TileInstance.get_cost tile_inst)
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

get_location : Struct.TileInstance.Type -> (Html.Html Struct.Event.Type)
get_location tile_inst =
   let
      tile_location = (Struct.TileInstance.get_location tile_inst)
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

get_mod_html : (String, Int) -> (Html.Html Struct.Event.Type)
get_mod_html mod =
   let
      (category, value) = mod
   in
      (Html.div
         [
            (Html.Attributes.class "info-card-mod")
         ]
         [
            (Html.text
               (category ++ ": " ++ (String.fromInt value))
            )
         ]
      )

get_omnimods_listing : (List (String, Int)) -> (Html.Html Struct.Event.Type)
get_omnimods_listing mod_list =
   (Html.div
      [
         (Html.Attributes.class "info-card-omnimods-listing")
      ]
      (List.map (get_mod_html) mod_list)
   )

get_omnimods : Struct.Omnimods.Type -> (Html.Html Struct.Event.Type)
get_omnimods omnimods =
   (Html.div
      [
         (Html.Attributes.class "info-card-omnimods")
      ]
      [
         (Html.text "Attribute Modifiers"),
         (get_omnimods_listing (Struct.Omnimods.get_attributes_mods omnimods)),
         (Html.text "Statistics Modifiers"),
         (get_omnimods_listing (Struct.Omnimods.get_statistics_mods omnimods)),
         (Html.text "Attack Modifiers"),
         (get_omnimods_listing (Struct.Omnimods.get_attack_mods omnimods)),
         (Html.text "Defense Modifiers"),
         (get_omnimods_listing (Struct.Omnimods.get_defense_mods omnimods))
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
               (Html.Attributes.class "info-card"),
               (Html.Attributes.class "tile-card")
            ]
            [
               (get_name model tile),
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
               (get_omnimods ((Struct.Model.tile_omnimods_fun model) loc))
            ]
         )

      Nothing -> (Html.text "Error: Unknown tile location selected.")
