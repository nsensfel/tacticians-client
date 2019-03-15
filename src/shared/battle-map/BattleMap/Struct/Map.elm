module BattleMap.Struct.Map exposing
   (
      Type,
      decoder,
      empty,
      get_height,
      get_markers,
      get_movement_cost_function,
      get_omnimods_at,
      get_tiles,
      get_width,
      new,
      set_tile_to,
      solve_tiles,
      try_getting_tile_at
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Json.Decode

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Marker
import BattleMap.Struct.Tile
import BattleMap.Struct.TileInstance

-- Local Module ----------------------------------------------------------------
import Constants.Movement

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      width : Int,
      height : Int,
      content : (Array.Array BattleMap.Struct.TileInstance.Type),
      markers : (Dict.Dict String BattleMap.Struct.Marker.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
location_to_index : BattleMap.Struct.Location.Type -> Type -> Int
location_to_index loc map =
   ((loc.y * map.width) + loc.x)

has_location : BattleMap.Struct.Location.Type -> Type -> Bool
has_location loc map =
   (
      (loc.x >= 0)
      && (loc.y >= 0)
      && (loc.x < map.width)
      && (loc.y < map.height)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_width : Type -> Int
get_width map = map.width

get_height : Type -> Int
get_height map = map.height

get_tiles : Type -> (Array.Array BattleMap.Struct.TileInstance.Type)
get_tiles map = map.content

get_markers : Type -> (Dict.Dict String BattleMap.Struct.Marker.Type)
get_markers map = map.markers

set_tile_to : BattleMap.Struct.Location.Type -> BattleMap.Struct.TileInstance.Type -> Type -> Type
set_tile_to loc tile_inst map =
   {map |
      content = (Array.set (location_to_index loc map) tile_inst map.content)
   }

empty : Type
empty =
   {
      width = 0,
      height = 0,
      content = (Array.empty),
      markers = (Dict.empty)
   }

new : Int -> Int -> (List BattleMap.Struct.TileInstance.Type) -> Type
new width height tiles =
   {
      width = width,
      height = height,
      content = (Array.fromList tiles),
      markers = (Dict.empty)
   }

try_getting_tile_at : (
      BattleMap.Struct.Location.Type ->
      Type ->
      (Maybe BattleMap.Struct.TileInstance.Type)
   )
try_getting_tile_at loc map =
   if (has_location loc map)
   then (Array.get (location_to_index loc map) map.content)
   else Nothing

solve_tiles : (
      (Dict.Dict BattleMap.Struct.Tile.Ref BattleMap.Struct.Tile.Type) ->
      Type ->
      Type
   )
solve_tiles tiles map =
   {map |
      content =
         (Array.map
            (BattleMap.Struct.TileInstance.solve tiles) map.content
         )
   }

get_omnimods_at : (
      BattleMap.Struct.Location.Type ->
      (Dict.Dict BattleMap.Struct.Tile.Ref BattleMap.Struct.Tile.Type) ->
      Type ->
      Battle.Struct.Omnimods.Type
   )
get_omnimods_at loc tiles_solver map =
   case (try_getting_tile_at loc map) of
      Nothing -> (Battle.Struct.Omnimods.none)
      (Just tile_inst) ->
         case
            (Dict.get
               (BattleMap.Struct.TileInstance.get_class_id tile_inst)
               tiles_solver
            )
         of
            Nothing -> (Battle.Struct.Omnimods.none)
            (Just tile) -> (BattleMap.Struct.Tile.get_omnimods tile)

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
                     (BattleMap.Struct.TileInstance.set_location_from_index
                        width
                     )
                  )
                  (Json.Decode.array (BattleMap.Struct.TileInstance.decoder))
               )
            )
            (Json.Decode.field
               "m"
               (Json.Decode.map
                  (Dict.fromList)
                  (Json.Decode.keyValuePairs
                     (BattleMap.Struct.Marker.decoder)
                  )
               )
            )
         )
      )
      (Json.Decode.field "w" Json.Decode.int)
   )

get_movement_cost_function : (
      Type ->
      (List BattleMap.Struct.Location.Type) ->
      BattleMap.Struct.Location.Type ->
      BattleMap.Struct.Location.Type ->
      Int
   )
get_movement_cost_function bmap occupied_tiles start_loc loc =
   if (has_location loc bmap)
   then
      case (Array.get (location_to_index loc bmap) bmap.content) of
         (Just tile) ->
            if ((loc /= start_loc) && (List.member loc occupied_tiles))
            then Constants.Movement.cost_when_occupied_tile
            else (BattleMap.Struct.TileInstance.get_cost tile)

         Nothing -> Constants.Movement.cost_when_out_of_bounds
   else
      Constants.Movement.cost_when_out_of_bounds
