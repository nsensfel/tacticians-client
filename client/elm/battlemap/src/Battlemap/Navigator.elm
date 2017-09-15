module Battlemap.Navigator exposing (Navigator, new_navigator, go)

import Set exposing (Set, member, empty, insert)

import Battlemap exposing (Battlemap, has_location, apply_to_tile)
import Battlemap.Location exposing (..)
import Battlemap.Direction exposing (..)
import Battlemap.Tile exposing (set_direction)

type alias Navigator =
   {
      current_location : Location,
      visited_locations : (Set LocationComparable)
   }

new_navigator : Location -> Navigator
new_navigator start =
   {
      current_location = start,
      visited_locations = empty
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
