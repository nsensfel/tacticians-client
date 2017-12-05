module ???.MoveNavigator exposing (to)

-- TODO: This should not belong to the Struct.Navigator module, as it's actually
-- a module used to manipulate an existing navigator in a certain way.

import Set
import List

import Struct.Battlemap
import Struct.Direction
import Struct.Location
import Struct.Tile
import Struct.Navigator

import Character

import Util.List

can_move_to_new_tile : (
      Struct.Navigator.Type ->
      Struct.Battlemap.Type ->
      Struct.Location.Type ->
      Bool
   )
can_move_to_new_tile nav battlemap next_location =
   (
      (nav.remaining_points > 0)
      && (Struct.Battlemap.has_location battlemap next_location)
      && (nav.current_location /= next_location)
      &&
      (not
         (Set.member
            (Struct.Location.get_ref next_location)
            nav.visited_locations
         )
      )
   )

battlemap_move_to : (
      Struct.Battlemap.Type ->
      Struct.Location.Type ->
      Struct.Direction.Type ->
      Struct.Location.Type ->
      Struct.Battlemap.Type
   )
battlemap_move_to battlemap current_loc dir next_loc =
   (Struct.Battlemap.apply_to_tile_unsafe
      (Struct.Battlemap.apply_to_tile_unsafe
         battlemap
         current_loc
         (Struct.Tile.set_direction dir)
      )
      next_loc
      (Struct.Tile.set_direction dir)
   )

navigator_move_to : (
      Struct.Navigator.Type ->
      Struct.Direction.Type ->
      Struct.Location.Type ->
      Struct.Navigator.Type
   )
navigator_move_to nav dir next_loc =
   {nav |
      current_location = next_loc,
      visited_locations =
         (Set.insert
            (Struct.Location.get_ref nav.current_location)
            nav.visited_locations
         ),
      previous_directions = (dir :: nav.previous_directions),
      remaining_points = (nav.remaining_points - 1)
   }

battlemap_backtrack : (
      Struct.Battlemap.Type ->
      Struct.Location.Type ->
      Struct.Battlemap.Type
   )
battlemap_backtrack battlemap current_loc =
   (Struct.Battlemap.apply_to_tile_unsafe
      battlemap
      current_loc
      (Struct.Tile.set_direction
         Struct.Direction.None
      )
   )

navigator_backtrack : (
      Struct.Navigator.Type ->
      Struct.Location.Type ->
      (List Struct.Direction.Type) ->
      Struct.Navigator.Type
   )
navigator_backtrack nav next_loc prev_dir_tail =
   {nav |
      current_location = next_loc,
      visited_locations =
         (Set.remove
            (Struct.Location.get_ref next_loc)
            nav.visited_locations
         ),
      previous_directions = prev_dir_tail,
      remaining_points = (nav.remaining_points + 1)
   }

to : (
      Struct.Battlemap.Type ->
      Struct.Navigator.Type ->
      Struct.Direction.Type ->
      (List Character.Type) ->
      (Struct.Battlemap.Type, Struct.Navigator.Type)
   )
to battlemap nav dir char_list =
   let
      next_location = (Struct.Location.neighbor nav.current_location dir)
      is_occupied =
         (List.any
            (\c -> ((Character.get_location c) == next_location))
            char_list
         )
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
                  if (head == (Struct.Direction.opposite_of dir))
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
