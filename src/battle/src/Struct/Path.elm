module Struct.Path exposing
   (
      Type,
      new,
      get_current_location,
      get_remaining_points,
      get_summary,
      maybe_follow_direction
   )

-- Elm -------------------------------------------------------------------------
import Set

-- Shared ----------------------------------------------------------------------
import Util.List

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Constants.Movement

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      current_location : BattleMap.Struct.Location.Type,
      visited_locations : (Set.Set BattleMap.Struct.Location.Ref),
      previous_directions : (List BattleMap.Struct.Direction.Type),
      previous_points : (List Int),
      remaining_points : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
has_been_to : (
      Type ->
      BattleMap.Struct.Location.Type ->
      Bool
   )
has_been_to path location =
   (
      (path.current_location == location)
      ||
      (Set.member
         (BattleMap.Struct.Location.get_ref location)
         path.visited_locations
      )
   )

maybe_mov_to : (
      Type ->
      BattleMap.Struct.Direction.Type ->
      BattleMap.Struct.Location.Type ->
      Int ->
      (Maybe Type)
   )
maybe_mov_to path dir next_loc cost =
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
                     (BattleMap.Struct.Location.get_ref path.current_location)
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

maybe_backtrack_to : (
      Type ->
      BattleMap.Struct.Direction.Type ->
      BattleMap.Struct.Location.Type ->
      (Maybe Type)
   )
maybe_backtrack_to path dir location =
   case
      (
         (Util.List.pop path.previous_directions),
         (Util.List.pop path.previous_points)
      )
   of
      (
         (Just (prev_dir_head, prev_dir_tail)),
         (Just (prev_pts_head, prev_pts_tail))) ->
         -- Does not compile in Elm 0.19 if I put the closing paren on this line
         (
            if (prev_dir_head == (BattleMap.Struct.Direction.opposite_of dir))
            then
               (Just
                  {path |
                     current_location = location,
                     visited_locations =
                        (Set.remove
                           (BattleMap.Struct.Location.get_ref location)
                           path.visited_locations
                        ),
                     previous_directions = prev_dir_tail,
                     previous_points = prev_pts_tail,
                     remaining_points = prev_pts_head
                  }
               )
            else
               Nothing
         )

      (_, _) ->
         Nothing

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------

new : BattleMap.Struct.Location.Type -> Int -> Type
new start points =
   {
      current_location = start,
      visited_locations = Set.empty,
      previous_directions = [],
      previous_points = [],
      remaining_points = points
   }

get_current_location : Type -> BattleMap.Struct.Location.Type
get_current_location path = path.current_location

get_remaining_points : Type -> Int
get_remaining_points path = path.remaining_points

get_summary : Type -> (List BattleMap.Struct.Direction.Type)
get_summary path = path.previous_directions

maybe_follow_direction : (
      (BattleMap.Struct.Location.Type -> (Int, Int)) ->
      (Maybe Type) ->
      BattleMap.Struct.Direction.Type ->
      (Maybe Type)
   )
maybe_follow_direction tile_data_fun maybe_path dir =
   case maybe_path of
      (Just path) ->
         let
            next_location =
               (BattleMap.Struct.Location.neighbor
                  dir
                  path.current_location
               )
            (next_location_cost, next_location_battles) =
               (tile_data_fun next_location)
         in
            if (next_location_cost <= Constants.Movement.max_points)
            then
               if (has_been_to path next_location)
               then
                  (maybe_backtrack_to path dir next_location)
               else
                  (maybe_mov_to
                     path
                     dir
                     next_location
                     next_location_cost
                  )
            else
               Nothing

      Nothing -> Nothing
