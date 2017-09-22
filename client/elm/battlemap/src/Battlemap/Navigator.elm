module Battlemap.Navigator exposing
   (
      Type,
      new_navigator,
      reset_navigation
   )

import Set -- exposing (Set, member, empty, insert, remove)

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


reset_navigation : Battlemap.Tile.Type -> Battlemap.Tile.Type
reset_navigation t =
   {t |
      nav_level = Battlemap.Direction.None
   }
