module Struct.Path exposing
   (
      Type,

      new,

      get_current_location,
      get_remaining_points,
      get_summary,

      maybe_add_step
   )

-- Elm -------------------------------------------------------------------------
import Set

-- Shared ----------------------------------------------------------------------
import Shared.Util.List

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
      BattleMap.Struct.Location.Type ->
      Type ->
      Bool
   )
has_been_to location path =
   (
      (path.current_location == location)
      ||
      (Set.member
         (BattleMap.Struct.Location.get_ref location)
         path.visited_locations
      )
   )

maybe_move_to : (
      BattleMap.Struct.Direction.Type ->
      BattleMap.Struct.Location.Type ->
      Int ->
      Type ->
      (Maybe Type)
   )
maybe_move_to dir next_loc cost path =
   let remaining_points = (path.remaining_points - cost) in
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
      BattleMap.Struct.Direction.Type ->
      BattleMap.Struct.Location.Type ->
      Type ->
      (Maybe Type)
   )
maybe_backtrack_to dir location path =
   case
      (
         (Shared.Util.List.pop path.previous_directions),
         (Shared.Util.List.pop path.previous_points)
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
      visited_locations = (Set.empty),
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

maybe_add_step : (
      BattleMap.Struct.Direction.Type ->
      (BattleMap.Struct.Location.Type -> (Int, Int)) ->
      Type ->
      (Maybe Type)
   )
maybe_add_step direction tile_cost_and_danger_fun path =
   let
      next_location =
         (BattleMap.Struct.Location.neighbor direction path.current_location)
   in
      if (has_been_to next_location path)
      then (maybe_backtrack_to direction next_location path)
      else
         let (cost, dangers) = (tile_cost_and_danger_fun next_location) in
            (maybe_move_to
               direction
               next_location
               cost
               path
            )
