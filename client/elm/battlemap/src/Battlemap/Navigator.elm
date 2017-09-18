module Battlemap.Navigator exposing
   (
      Navigator,
      new_navigator,
      reset_navigation,
      go
   )

import Set exposing (Set, member, empty, insert)

import Battlemap exposing (Battlemap, has_location, apply_to_tile)
import Battlemap.Direction exposing (Direction(..))
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
      visited_locations : (Set LocationRef)
   }

new_navigator : Location -> Navigator
new_navigator start =
   {
      current_location = start,
      visited_locations = empty
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
                  (Just bmap) -> bmap
            ),
            {
               current_location = next_location,
               visited_locations =
                  (insert
                     (to_comparable nav.current_location)
                     nav.visited_locations
                  )
            }
         )
      else
         (
            battlemap,
            nav
         )
