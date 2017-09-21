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
      previous_directions : (List Direction)
   }

new_navigator : Location -> Navigator
new_navigator start =
   {
      current_location = start,
      visited_locations = empty,
      previous_directions = []
   }


reset_navigation : Tile -> Tile
reset_navigation t =
   {t |
      nav_level = None
   }

go : Battlemap -> Navigator -> Direction -> (Battlemap, Navigator)
go battlemap nav dir =
   let
      next_location = (neighbor nav.current_location dir)
   in
      if
      (
         (has_location battlemap next_location)
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
               previous_directions = (dir :: nav.previous_directions)
            }
         )
      else
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
                        previous_directions = prev_dir_list
                     }
                  )
               else
                  (battlemap, nav)
