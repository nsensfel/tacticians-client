module Struct.Battlemap exposing
   (
      Type,
      empty,
      new,
      get_width,
      get_height,
      get_tiles,
      get_movement_cost_function,
      solve_tiles,
      try_getting_tile_at
   )

-- Elm -------------------------------------------------------------------------
import Array

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Tile
import Struct.Location

import Constants.Movement

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

get_tiles : Type -> (Array.Array Struct.Tile.Instance)
get_tiles bmap = bmap.content

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
try_getting_tile_at loc bmap =
   (Array.get (location_to_index loc bmap) bmap.content)

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
                        )
                  )
                  char_list
               )
            then
               Constants.Movement.cost_when_occupied_tile
            else
               (Struct.Tile.get_instance_cost tile)

         Nothing -> Constants.Movement.cost_when_out_of_bounds
   else
      Constants.Movement.cost_when_out_of_bounds

solve_tiles : (List Struct.Tile.Type) -> Type -> Type
solve_tiles tiles bmap =
   {bmap |
      content = (Array.map (Struct.Tile.solve_tile_instance tiles) bmap.content)
   }
