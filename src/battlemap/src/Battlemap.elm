module Battlemap exposing
   (
      Type,
      reset,
      get_navigator_remaining_points,
      get_tiles,
      set_navigator,
      try_getting_navigator_location,
      try_getting_navigator_path_to,
      try_getting_navigator_summary,
      try_adding_step_to_navigator
   )

import Array

import Battlemap.Navigator
import Battlemap.Tile
import Battlemap.Direction
import Battlemap.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      width: Int,
      height: Int,
      content: (Array.Array Battlemap.Tile.Type),
      navigator: (Maybe Battlemap.Navigator.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
location_to_index : Type -> Battlemap.Location.Type -> Int
location_to_index bmap loc =
   ((loc.y * bmap.width) + loc.x)

has_location : Type -> Battlemap.Location.Type -> Bool
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
get_tiles : Type -> (Array.Array Battlemap.Tile.Type)
get_tiles bmap = bmap.content

reset : Type -> Type
reset bmap =
   {bmap |
      navigator = Nothing
   }

try_getting_navigator_location : Type -> (Maybe Battlemap.Location.Type)
try_getting_navigator_location bmap =
   case bmap.navigator of
      (Just navigator) ->
         (Just (Battlemap.Navigator.get_current_location navigator))

      Nothing -> Nothing

get_navigator_remaining_points : Type -> Int
get_navigator_remaining_points bmap =
   case bmap.navigator of
      (Just navigator) -> (Battlemap.Navigator.get_remaining_points navigator)
      Nothing -> -1

set_navigator : (
      Battlemap.Location.Type ->
      Int ->
      Int ->
      (Battlemap.Location.Type -> Bool) ->
      Type ->
      Type
   )
set_navigator start_loc movement_points attack_range can_cross bmap =
   {bmap |
      navigator =
         (Just
            (Battlemap.Navigator.new
               start_loc
               movement_points
               attack_range
               (\loc -> ((can_cross loc) && (has_location bmap loc)))
               (\loc ->
                  case
                     (Array.get (location_to_index bmap loc) bmap.content)
                  of
                     (Just tile) -> (Battlemap.Tile.get_cost tile)
                     Nothing -> 99
               )
            )
         )
   }

try_adding_step_to_navigator : (
      Type ->
      (Battlemap.Location.Type -> Bool) ->
      Battlemap.Direction.Type ->
      (Maybe Type)
   )
try_adding_step_to_navigator bmap can_cross dir =
   case bmap.navigator of
      (Just navigator) ->
         let
            new_navigator =
               (Battlemap.Navigator.try_adding_step
                  navigator
                  dir
                  (\loc -> ((can_cross loc) && (has_location bmap loc)))
                  (\loc ->
                     case
                        (Array.get (location_to_index bmap loc) bmap.content)
                     of
                        (Just tile) -> (Battlemap.Tile.get_cost tile)
                        Nothing -> 99
                  )
               )
         in
          case new_navigator of
            (Just _) -> (Just {bmap | navigator = new_navigator})
            Nothing -> Nothing

      _ -> Nothing

try_getting_navigator_summary : Type -> (Maybe Battlemap.Navigator.Summary)
try_getting_navigator_summary bmap =
   case bmap.navigator of
      (Just navigator) -> (Just (Battlemap.Navigator.get_summary navigator))
      Nothing -> Nothing

try_getting_navigator_path_to : (
      Type ->
      Battlemap.Location.Ref ->
      (Maybe (List Battlemap.Direction.Type))
   )
try_getting_navigator_path_to bmap loc_ref =
   case bmap.navigator of
      (Just navigator) ->
         (Battlemap.Navigator.try_getting_path_to navigator loc_ref)

      Nothing -> Nothing

