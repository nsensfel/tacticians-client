module Battlemap exposing
   (
      Type,
      new,
      reset,
      get_navigator_remaining_points,
      get_tiles,
      set_navigator,
      clear_navigator_path,
      get_navigator_path,
      try_getting_tile_at,
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

import Character

import Constants.Movement

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

tile_cost_function : (
      Type ->
      Battlemap.Location.Type ->
      (List Character.Type) ->
      Battlemap.Location.Type ->
      Int
   )
tile_cost_function bmap start_loc char_list loc =
   if
      (
         (Battlemap.Location.get_ref start_loc)
         ==
         (Battlemap.Location.get_ref loc)
      )
   then
      0
   else
      if (has_location bmap loc)
      then
         case
            (Array.get (location_to_index bmap loc) bmap.content)
         of
            (Just tile) ->
               if
                  (List.any
                     (\c -> ((Character.get_location c) == loc))
                     char_list
                  )
               then
                  Constants.Movement.cost_when_occupied_tile
               else
                  (Battlemap.Tile.get_cost tile)

            Nothing -> Constants.Movement.cost_when_out_of_bounds
      else
         Constants.Movement.cost_when_out_of_bounds

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_tiles : Type -> (Array.Array Battlemap.Tile.Type)
get_tiles bmap = bmap.content

new : Int -> Int -> (List Battlemap.Tile.Type) -> Type
new width height tiles =
   {
      width = width,
      height = height,
      content = (Array.fromList tiles),
      navigator = Nothing
   }

reset : Type -> Type
reset bmap =
   {bmap |
      navigator = Nothing
   }

clear_navigator_path : Type -> Type
clear_navigator_path bmap =
   case bmap.navigator of
      (Just navigator) ->
         {bmap | navigator = (Just (Battlemap.Navigator.clear_path navigator))}

      Nothing -> bmap

get_navigator_path : Type -> (List Battlemap.Direction.Type)
get_navigator_path bmap =
   case bmap.navigator of
      (Just navigator) -> (Battlemap.Navigator.get_path navigator)
      Nothing -> []

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
      (List Character.Type) ->
      Type ->
      Type
   )
set_navigator start_loc movement_points attack_range character_list bmap =
   {bmap |
      navigator =
         (Just
            (Battlemap.Navigator.new
               start_loc
               movement_points
               attack_range
               (tile_cost_function
                  bmap
                  start_loc
                  character_list
               )
            )
         )
   }

try_getting_tile_at : (
      Type ->
      Battlemap.Location.Type ->
      (Maybe Battlemap.Tile.Type)
   )
try_getting_tile_at bmap loc =
   (Array.get (location_to_index bmap loc) bmap.content)

try_adding_step_to_navigator : (
      Type ->
      (List Character.Type) ->
      Battlemap.Direction.Type ->
      (Maybe Type)
   )
try_adding_step_to_navigator bmap character_list dir =
   case bmap.navigator of
      (Just navigator) ->
         let
            new_navigator =
               (Battlemap.Navigator.try_adding_step
                  navigator
                  dir
                  (tile_cost_function
                     bmap
                     (Battlemap.Navigator.get_starting_location navigator)
                     character_list
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

