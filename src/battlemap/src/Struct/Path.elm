module Struct.Path exposing
   (
      Type,
      new,
      get_current_location,
      get_remaining_points,
      get_summary,
      try_following_direction
   )

-- Elm -------------------------------------------------------------------------
import Set

-- Battlemap -------------------------------------------------------------------
import Struct.Direction
import Struct.Location

import Util.List

import Constants.Movement

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      current_location : Struct.Location.Type,
      visited_locations : (Set.Set Struct.Location.Ref),
      previous_directions : (List Struct.Direction.Type),
      previous_points : (List Int),
      remaining_points : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
has_been_to : (
      Type ->
      Struct.Location.Type ->
      Bool
   )
has_been_to path location =
   (
      (path.current_location == location)
      ||
      (Set.member
         (Struct.Location.get_ref location)
         path.visited_locations
      )
   )

try_moving_to : (
      Type ->
      Struct.Direction.Type ->
      Struct.Location.Type ->
      Int ->
      (Maybe Type)
   )
try_moving_to path dir next_loc cost =
   let
      remaining_points = (path.remaining_points - cost)
   in
      if (remaining_points >= 0)
      then
         (Just
            {path |
               current_location = next_loc,
               visited_locations =
                  (Set.insert
                     (Struct.Location.get_ref path.current_location)
                     path.visited_locations
                  ),
               previous_directions = (dir :: path.previous_directions),
               previous_points =
                  (path.remaining_points :: path.previous_points),
               remaining_points = remaining_points
            }
         )
      else
         Nothing

try_backtracking_to : (
      Type ->
      Struct.Direction.Type ->
      Struct.Location.Type ->
      (Maybe Type)
   )
try_backtracking_to path dir location =
   case
      (
         (Util.List.pop path.previous_directions),
         (Util.List.pop path.previous_points)
      )
   of
      (
         (Just (prev_dir_head, prev_dir_tail)),
         (Just (prev_pts_head, prev_pts_tail))
      ) ->
         if (prev_dir_head == (Struct.Direction.opposite_of dir))
         then
            (Just
               {path |
                  current_location = location,
                  visited_locations =
                     (Set.remove
                        (Struct.Location.get_ref location)
                        path.visited_locations
                     ),
                  previous_directions = prev_dir_tail,
                  previous_points = prev_pts_tail,
                  remaining_points = prev_pts_head
               }
            )
         else
            Nothing
      (_, _) ->
         Nothing

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------

new : Struct.Location.Type -> Int -> Type
new start points =
   {
      current_location = start,
      visited_locations = Set.empty,
      previous_directions = [],
      previous_points = [],
      remaining_points = points
   }

get_current_location : Type -> Struct.Location.Type
get_current_location path = path.current_location

get_remaining_points : Type -> Int
get_remaining_points path = path.remaining_points

get_summary : Type -> (List Struct.Direction.Type)
get_summary path = path.previous_directions

try_following_direction : (
      (Struct.Location.Type -> Int) ->
      (Maybe Type) ->
      Struct.Direction.Type ->
      (Maybe Type)
   )
try_following_direction cost_fun maybe_path dir =
   case maybe_path of
      (Just path) ->
         let
            next_location =
               (Struct.Location.neighbor
                  path.current_location
                  dir
               )
            next_location_cost = (cost_fun next_location)
         in
            if (next_location_cost <= Constants.Movement.max_points)
            then
               if (has_been_to path next_location)
               then
                  (try_backtracking_to path dir next_location)
               else
                  (try_moving_to
                     path
                     dir
                     next_location
                     next_location_cost
                  )
            else
               Nothing
      Nothing -> Nothing
