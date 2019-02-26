module Struct.Map exposing
   (
      Type,
      empty,
      new,
      get_width,
      get_height,
      get_tiles,
      get_movement_cost_function,
      solve_tiles,
      try_getting_tile_at,
      get_omnimods_at,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Json.Decode

-- Battle ----------------------------------------------------------------------
import Constants.Movement

import Struct.Character
import Struct.Location
import Struct.Omnimods
import Struct.Tile
import Struct.TileInstance
import Struct.MapMarker

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      width : Int,
      height : Int,
      content : (Array.Array Struct.TileInstance.Type),
      markers : (Dict.Dict String Struct.MapMarker.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
location_to_index : Struct.Location.Type -> Type -> Int
location_to_index loc bmap =
   ((loc.y * bmap.width) + loc.x)

has_location : Struct.Location.Type -> Type -> Bool
has_location loc bmap =
   (
      (loc.x >= 0)
      && (loc.y >= 0)
      && (loc.x < bmap.width)
      && (loc.y < bmap.height)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_width : Type -> Int
get_width bmap = bmap.width

get_height : Type -> Int
get_height bmap = bmap.height

get_tiles : Type -> (Array.Array Struct.TileInstance.Type)
get_tiles map = map.content

empty : Type
empty =
   {
      width = 0,
      height = 0,
      content = (Array.empty),
      markers = (Dict.empty)
   }

new : Int -> Int -> (List Struct.TileInstance.Type) -> Type
new width height tiles =
   {
      width = width,
      height = height,
      content = (Array.fromList tiles),
      markers = (Dict.empty)
   }

try_getting_tile_at : (
      Struct.Location.Type ->
      Type ->
      (Maybe Struct.TileInstance.Type)
   )
try_getting_tile_at loc map =
   if (has_location loc map)
   then (Array.get (location_to_index loc map) map.content)
   else Nothing

get_movement_cost_function : (
      Type ->
      Struct.Location.Type ->
      (List Struct.Character.Type) ->
      Struct.Location.Type ->
      Int
   )
get_movement_cost_function bmap start_loc char_list loc =
   if (has_location loc bmap)
   then
      case (Array.get (location_to_index loc bmap) bmap.content) of
         (Just tile) ->
            if
               (List.any
                  (
                     \c ->
                        (
                           ((Struct.Character.get_location c) == loc)
                           && (loc /= start_loc)
                           && (Struct.Character.is_alive c)
                        )
                  )
                  char_list
               )
            then
               Constants.Movement.cost_when_occupied_tile
            else
               (Struct.TileInstance.get_cost tile)

         Nothing -> Constants.Movement.cost_when_out_of_bounds
   else
      Constants.Movement.cost_when_out_of_bounds

get_omnimods_at : (
      Struct.Location.Type ->
      (Dict.Dict Struct.Tile.Ref Struct.Tile.Type) ->
      Type ->
      Struct.Omnimods.Type
   )
get_omnimods_at loc tiles_solver map =
   case (try_getting_tile_at loc map) of
      Nothing -> (Struct.Omnimods.new [] [] [] [])
      (Just tile_inst) ->
         case
            (Dict.get (Struct.TileInstance.get_class_id tile_inst) tiles_solver)
         of
            Nothing -> (Struct.Omnimods.new [] [] [] [])
            (Just tile) -> (Struct.Tile.get_omnimods tile)

solve_tiles : (Dict.Dict Struct.Tile.Ref Struct.Tile.Type) -> Type -> Type
solve_tiles tiles map =
   {map |
      content = (Array.map (Struct.TileInstance.solve tiles) map.content)
   }

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.andThen
      (\width ->
         (Json.Decode.map4
            Type
            (Json.Decode.field "w" Json.Decode.int)
            (Json.Decode.field "h" Json.Decode.int)
            (Json.Decode.field
               "t"
               (Json.Decode.map
                  (Array.indexedMap
                     (Struct.TileInstance.set_location_from_index width)
                  )
                  (Json.Decode.array (Struct.TileInstance.decoder))
               )
            )
            (Json.Decode.field
               "m"
               (Json.Decode.map
                  (Dict.fromList)
                  (Json.Decode.keyValuePairs (Struct.MapMarker.decoder))
               )
            )
         )
      )
      (Json.Decode.field "w" Json.Decode.int)
   )
