module Struct.Map exposing
   (
      Type,
      empty,
      new,
      get_width,
      get_height,
      get_tiles,
      set_tile_to,
      solve_tiles,
      try_getting_tile_at
   )

-- Elm -------------------------------------------------------------------------
import Array

-- Map -------------------------------------------------------------------
import Struct.Tile
import Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      width: Int,
      height: Int,
      content: (Array.Array Struct.Tile.Instance)
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

get_tiles : Type -> (Array.Array Struct.Tile.Instance)
get_tiles map = map.content

set_tile_to : Struct.Location.Type -> Struct.Tile.Instance -> Type -> Type
set_tile_to loc tile_inst map =
   {map |
      content = (Array.set (location_to_index loc map) tile_inst map.content)
   }

empty : Type
empty =
   {
      width = 0,
      height = 0,
      content = (Array.empty)
   }

new : Int -> Int -> (List Struct.Tile.Instance) -> Type
new width height tiles =
   {
      width = width,
      height = height,
      content = (Array.fromList tiles)
   }

try_getting_tile_at : (
      Struct.Location.Type ->
      Type ->
      (Maybe Struct.Tile.Instance)
   )
try_getting_tile_at loc map =
   if (has_location loc map)
   then (Array.get (location_to_index loc map) map.content)
   else Nothing

solve_tiles : (List Struct.Tile.Type) -> Type -> Type
solve_tiles tiles map =
   {map |
      content = (Array.map (Struct.Tile.solve_tile_instance tiles) map.content)
   }
