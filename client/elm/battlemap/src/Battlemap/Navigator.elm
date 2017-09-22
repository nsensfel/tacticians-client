module Battlemap.Navigator exposing
   (
      Type,
      new_navigator
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
      remaining_points : Int
   }

new_navigator : Battlemap.Location.Type -> Int -> Type
new_navigator start points =
   {
      current_location = start,
      visited_locations = Set.empty,
      previous_directions = [],
      remaining_points = points
   }
