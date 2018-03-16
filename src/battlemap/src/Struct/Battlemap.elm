module Struct.Battlemap exposing
   (
      Type,
      empty,
      new,
      get_width,
      get_height,
      get_tiles,
      get_movement_cost_function,
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
      content: (Array.Array Struct.Tile.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
location_to_index : Type -> Struct.Location.Type -> Int
location_to_index bmap loc =
   ((loc.y * bmap.width) + loc.x)

has_location : Type -> Struct.Location.Type -> Bool
has_location bmap loc =
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

get_tiles : Type -> (Array.Array Struct.Tile.Type)
get_tiles bmap = bmap.content

empty : Type
empty =
   {
      width = 0,
      height = 0,
      content = (Array.empty)
   }

new : Int -> Int -> (List Struct.Tile.Type) -> Type
new width height tiles =
   {
      width = width,
      height = height,
      content = (Array.fromList tiles)
   }

try_getting_tile_at : (
      Type ->
      Struct.Location.Type ->
      (Maybe Struct.Tile.Type)
   )
try_getting_tile_at bmap loc =
   (Array.get (location_to_index bmap loc) bmap.content)

get_movement_cost_function : (
      Type ->
      Struct.Location.Type ->
      (List Struct.Character.Type) ->
      Struct.Location.Type ->
      Int
   )
get_movement_cost_function bmap start_loc char_list loc =
   if (has_location bmap loc)
   then
      case
         (Array.get (location_to_index bmap loc) bmap.content)
      of
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
               (Struct.Tile.get_cost tile)

         Nothing -> Constants.Movement.cost_when_out_of_bounds
   else
      Constants.Movement.cost_when_out_of_bounds
