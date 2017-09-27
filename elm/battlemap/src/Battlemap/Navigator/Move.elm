module Battlemap.Navigator.Move exposing (to)

import Set
import List

import Battlemap
import Battlemap.Direction
import Battlemap.Location
import Battlemap.Tile
import Battlemap.Navigator

import Character

import Util.List

can_move_to_new_tile : (
      Battlemap.Navigator.Type ->
      Battlemap.Type ->
      Battlemap.Location.Type ->
      Bool
   )
can_move_to_new_tile nav battlemap next_location =
   (
      (nav.remaining_points > 0)
      && (Battlemap.has_location battlemap next_location)
      && (nav.current_location /= next_location)
      &&
      (not
         (Set.member
            (Battlemap.Location.get_ref next_location)
            nav.visited_locations
         )
      )
   )

battlemap_move_to : (
      Battlemap.Type ->
      Battlemap.Location.Type ->
      Battlemap.Direction.Type ->
      Battlemap.Location.Type ->
      Battlemap.Type
   )
battlemap_move_to battlemap current_loc dir next_loc =
   (Battlemap.apply_to_tile_unsafe
      (Battlemap.apply_to_tile_unsafe
         battlemap
         current_loc
         (Battlemap.Tile.set_direction dir)
      )
      next_loc
      (Battlemap.Tile.set_direction dir)
   )

navigator_move_to : (
      Battlemap.Navigator.Type ->
      Battlemap.Direction.Type ->
      Battlemap.Location.Type ->
      Battlemap.Navigator.Type
   )
navigator_move_to nav dir next_loc =
   {nav |
      current_location = next_loc,
      visited_locations =
         (Set.insert
            (Battlemap.Location.get_ref nav.current_location)
            nav.visited_locations
         ),
      previous_directions = (dir :: nav.previous_directions),
      remaining_points = (nav.remaining_points - 1)
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
navigator_backtrack nav next_loc prev_dir_tail =
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
      Battlemap.Type ->
      Battlemap.Navigator.Type ->
      Battlemap.Direction.Type ->
      (List Character.Type) ->
      (Battlemap.Type, Battlemap.Navigator.Type)
   )
to battlemap nav dir char_list =
   let
      next_location = (Battlemap.Location.neighbor nav.current_location dir)
      is_occupied = (List.any (\c -> (c.location == next_location)) char_list)
   in
      if (not is_occupied)
      then
         if (can_move_to_new_tile nav battlemap next_location)
         then
            (
               (battlemap_move_to
                  battlemap
                  nav.current_location
                  dir
                  next_location
               ),
               (navigator_move_to
                  nav
                  dir
                  next_location
               )
            )
         else
            case (Util.List.pop nav.previous_directions) of
               Nothing -> (battlemap, nav)
               (Just (head, tail)) ->
                  if (head == (Battlemap.Direction.opposite_of dir))
                  then
                     (
                        (battlemap_backtrack
                           battlemap
                           nav.current_location
                        ),
                        (navigator_backtrack
                           nav
                           next_location
                           tail
                        )
                     )
                  else
                     (battlemap, nav)
      else
         (battlemap, nav)
