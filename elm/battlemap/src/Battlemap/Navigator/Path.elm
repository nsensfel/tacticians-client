module Battlemap.Navigator.Path exposing
   (
      Type,
      new,
      get_current_location,
      get_remaining_points,
      follow_directions
   )

import Set

import Battlemap.Direction
import Battlemap.Location
import Battlemap.Tile

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      current_location : Battlemap.Location.Type,
      visited_locations : (Set.Set Battlemap.Location.Ref),
      previous_directions : (List Battlemap.Direction.Type),
      remaining_points : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
has_not_been_to : (
      Type ->
      Battlemap.Location.Type ->
      Bool
   )
has_not_been_to path location =
   (
      (path.current_location /= location)
      &&
      (not
         (Set.member
            (Battlemap.Location.get_ref location)
            path.visited_locations
         )
      )
   )

move_to : (
      Type ->
      Battlemap.Direction.Type ->
      Battlemap.Location.Type ->
      Int ->
      Type
   )
move_to path dir next_loc cost =
   {path |
      current_location = next_loc,
      visited_locations =
         (Set.insert
            (Battlemap.Location.get_ref path.current_location)
            path.visited_locations
         ),
      previous_directions = (dir :: path.previous_directions),
      remaining_points = (path.remaining_points - cost)
   }

battlemap_backtrack : (
      Battlemap.Type ->
      Battlemap.Location.Type ->
      Battlemap.Type
   )
battlemap_backtrack battlemap current_loc =
   (Battlemap.apply_to_tile_unsafe
      battlemap
      current_loc
      (Battlemap.Tile.set_direction
         Battlemap.Direction.None
      )
   )

navigator_backtrack : (
      Battlemap.Navigator.Type ->
      Battlemap.Location.Type ->
      (List Battlemap.Direction.Type) ->
      Battlemap.Navigator.Type
   )
try_backtracking_to path location dir =
               case (Util.List.pop nav.previous_directions) of
                     (Just (head, tail)) ->
                        if (head == (Battlemap.Direction.opposite_of dir))
                        then
                           (backtrack_to
                              nav
                              next_location
                              tail
                           )
                           )
                        else
                           (battlemap, nav)
                     Nothing -> (battlemap, nav)
               move_to path next_location
               if (can_move_to_new_tile path next_location)
               then
               else
   {nav |
      current_location = next_loc,
      visited_locations =
         (Set.remove
            (Battlemap.Location.get_ref next_loc)
            nav.visited_locations
         ),
      previous_directions = prev_dir_tail,
      remaining_points = (nav.remaining_points + 1)
   }


to : (
      Type ->
      Battlemap.Direction.Type ->
      (Battlemap.Type, Battlemap.Navigator.Type)
   )
to battlemap nav dir char_list =

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------

new : Battlemap.Location.Type -> Int -> Type
new start points =
   {
      current_location = start,
      visited_locations = Set.empty,
      previous_directions = [],
      remaining_points = points
   }

get_current_location : Type -> Battlemap.Location.Type
get_current_location path = path.current_location

get_remaining_points : Type -> Int
get_remaining_points path = path.remaining_points

follow_direction : (
      (Battlemap.Location.Type -> Bool) ->
      (Maybe Type) ->
      Battlemap.Direction.Type ->
      (Maybe Type)
   )
follow_direction can_cross cost_fun maybe_path dir =
   case maybe_path of
      (Just path) ->
         let
            next_location =
               (Battlemap.Location.neighbor
                  nav.current_location
                  dir
               )
         in
            if (can_cross path next_location)
            then
               if (has_not_been_to path next_location)
               then
                  (Just (move_to path next_location dir))
               else
                  (try_backtracking_to path next_location dir)
            else
               Nothing
            else
               (battlemap, nav)

      Nothing -> Nothing
