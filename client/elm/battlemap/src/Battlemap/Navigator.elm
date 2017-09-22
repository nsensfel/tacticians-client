module Battlemap.Navigator exposing
   (
      Type,
      new_navigator,
      reset_navigation,
      go
   )

import Set -- exposing (Set, member, empty, insert, remove)
import List -- exposing (head, tail)

import Battlemap
import Battlemap.Direction
import Battlemap.Location
import Battlemap.Tile

import Character

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

go : (
      Battlemap.Type ->
      Type ->
      Battlemap.Direction.Type ->
      (List Character.Type) ->
      (Battlemap.Type, Type)
   )
go battlemap nav dir char_list =
   let
      next_location = (Battlemap.Location.neighbor nav.current_location dir)
      is_occupied = (List.any (\c -> (c.location == next_location)) char_list)
   in
      if
      (
         (not is_occupied)
         && (nav.remaining_points > 0)
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
      then
         (
            (case
               (Battlemap.apply_to_tile
                  battlemap
                  nav.current_location
                  (Battlemap.Tile.set_direction dir)
               )
               of
                  Nothing -> battlemap
                  (Just bmap0) ->
                     (case
                        (Battlemap.apply_to_tile
                           bmap0
                           next_location
                           (Battlemap.Tile.set_direction dir)
                        )
                     of
                        Nothing -> battlemap
                        (Just bmap1) -> bmap1
                     )
            ),
            {nav |
               current_location = next_location,
               visited_locations =
                  (Set.insert
                     (Battlemap.Location.get_ref nav.current_location)
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
               (List.head nav.previous_directions),
               (List.tail nav.previous_directions)
            )
         of
            (Nothing, _) -> (battlemap, nav)
            (_ , Nothing) -> (battlemap, nav)
            ((Just prev_dir), (Just prev_dir_list)) ->
               if (dir == (Battlemap.Direction.opposite_of prev_dir))
               then
                  (
                     (case
                        (Battlemap.apply_to_tile
                           battlemap
                           nav.current_location
                           (Battlemap.Tile.set_direction
                              Battlemap.Direction.None
                           )
                        )
                        of
                           Nothing -> battlemap
                           (Just bmap) -> bmap
                     ),
                     {nav |
                        current_location = next_location,
                        visited_locations =
                           (Set.remove
                              (Battlemap.Location.get_ref next_location)
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
