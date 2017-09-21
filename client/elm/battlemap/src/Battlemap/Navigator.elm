module Battlemap.Navigator exposing
   (
      Navigator,
      new_navigator,
      reset_navigation,
      go
   )

import Set exposing (Set, member, empty, insert, remove)
import List as Lt exposing (head, tail)

import Battlemap exposing (Battlemap, has_location, apply_to_tile)
import Battlemap.Direction exposing (Direction(..), opposite_of)
import Battlemap.Tile exposing (Tile, set_direction)
import Character exposing (Character)

import Battlemap.Location exposing
   (
      Location,
      LocationRef,
      neighbor,
      to_comparable
   )

type alias Navigator =
   {
      current_location : Location,
      visited_locations : (Set LocationRef),
      previous_directions : (List Direction),
      remaining_points : Int
   }

new_navigator : Location -> Int -> Navigator
new_navigator start points =
   {
      current_location = start,
      visited_locations = empty,
      previous_directions = [],
      remaining_points = points
   }


reset_navigation : Tile -> Tile
reset_navigation t =
   {t |
      nav_level = None
   }

go : Battlemap -> Navigator -> Direction -> (List Character) -> (Battlemap, Navigator)
go battlemap nav dir char_list =
   let
      next_location = (neighbor nav.current_location dir)
      is_occupied = (Lt.any (\c -> (c.location == next_location)) char_list)
   in
      if
      (
         (not is_occupied)
         && (nav.remaining_points > 0)
         && (has_location battlemap next_location)
         && (nav.current_location /= next_location)
         && (not (member (to_comparable next_location) nav.visited_locations))
      )
      then
         (
            (case
               (apply_to_tile
                  battlemap
                  nav.current_location
                  (set_direction dir)
               )
               of
                  Nothing -> battlemap
                  (Just bmap0) ->
                     (case
                        (apply_to_tile
                           bmap0
                           next_location
                           (set_direction dir)
                        )
                     of
                        Nothing -> battlemap
                        (Just bmap1) -> bmap1
                     )
            ),
            {nav |
               current_location = next_location,
               visited_locations =
                  (insert
                     (to_comparable nav.current_location)
                     nav.visited_locations
                  ),
               previous_directions = (dir :: nav.previous_directions),
               remaining_points = (nav.remaining_points - 1)
            }
         )
      else if (not is_occupied)
      then
         case
            (
               (Lt.head nav.previous_directions),
               (Lt.tail nav.previous_directions)
            )
         of
            (Nothing, _) -> (battlemap, nav)
            (_ , Nothing) -> (battlemap, nav)
            ((Just prev_dir), (Just prev_dir_list)) ->
               if (dir == (opposite_of prev_dir))
               then
                  (
                     (case
                        (apply_to_tile
                           battlemap
                           nav.current_location
                           (set_direction None)
                        )
                        of
                           Nothing -> battlemap
                           (Just bmap) -> bmap
                     ),
                     {nav |
                        current_location = next_location,
                        visited_locations =
                           (remove
                              (to_comparable next_location)
                              nav.visited_locations
                           ),
                        previous_directions = prev_dir_list,
                        remaining_points = (nav.remaining_points + 1)
                     }
                  )
               else
                  (battlemap, nav)
      else
         (battlemap, nav)
