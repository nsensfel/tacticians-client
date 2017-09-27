module Battlemap.Navigator exposing
   (
      Type,
      new,
      reset
   )

import Set

import Battlemap
import Battlemap.Direction
import Battlemap.Location
import Battlemap.Tile


type alias Type =
   {
      current_location : Battlemap.Location.Type,
      visited_locations : (Set.Set Battlemap.Location.Ref),
      previous_directions : (List Battlemap.Direction.Type),
      remaining_points : Int,
      starting_location : Battlemap.Location.Type,
      starting_points : Int
   }

new : Battlemap.Location.Type -> Int -> Type
new start points =
   {
      current_location = start,
      visited_locations = Set.empty,
      previous_directions = [],
      remaining_points = points,
      starting_location = start,
      starting_points = points
   }

reset : Type -> Type
reset nav =
   {nav |
      current_location = nav.starting_location,
      visited_locations = Set.empty,
      previous_directions = [],
      remaining_points = nav.starting_points
   }
