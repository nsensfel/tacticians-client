module Struct.Map exposing
   (
      Type,
      empty,
      new,
      get_width,
      get_height,
      get_markers,
      get_tiles,
      set_tile_to,
      solve_tiles,
      try_getting_tile_at,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Json.Decode

-- Map Editor ------------------------------------------------------------------
import Struct.Tile
import Struct.Location
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
location_to_index loc map =
   ((loc.y * map.width) + loc.x)

has_location : Struct.Location.Type -> Type -> Bool
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

get_tiles : Type -> (Array.Array Struct.TileInstance.Type)
get_tiles map = map.content

get_markers : Type -> (Dict.Dict String Struct.MapMarker.Type)
get_markers map = map.markers

set_tile_to : Struct.Location.Type -> Struct.TileInstance.Type -> Type -> Type
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
