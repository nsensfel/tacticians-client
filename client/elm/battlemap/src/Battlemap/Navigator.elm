module Battlemap.Navigator exposing (Navigator, new_navigator, go)

import Set exposing (Set, member, empty)

import Battlemap exposing (Battlemap, has_location)
import Battlemap.Location exposing (..)
import Battlemap.Direction exposing (..)
import Battlemap.Tile exposing (set_tile_direction)

type alias Navigator =
   {
      current_location : Location,
      visited_locations : (Set Location)
   }

new_navigator : Location -> Navigator
new_navigator start =
   {
      current_location = start,
      visited_locations = empty
   }

go : Navigator -> Direction -> (Battlemap, Navigator)
go battlemap nav dir =
   let
      next_location = (neighbor nav.current_location dir)
   in
      if
      (
         (has_location battlemap next_location)
         && (current_location != next_location)
         && (not (member next_location nav.visited_locations))
      )
      then
         (
            (set_tile_direction
               nav.current_location
               dir
            ),
            {
               current_location = next_location,
               visited_locations =
                  (insert
                     nav.current_location
                     nav.visited_locations
                  )
            }
         )
      else
         nav
