module Battlemap.RangeIndicator exposing (Type, generate)

import Dict
import List

import Battlemap
import Battlemap.Direction
import Battlemap.Location

import Util.List

type alias Type =
   {
      distance: Int,
      path: (List Battlemap.Direction.Type),
      node_cost: Int
   }

generate_grid : (
      Battlemap.Location.Type ->
      Int ->
      Int ->
      Int ->
      Int ->
      (List Battlemap.Location.Type) ->
      (List Battlemap.Location.Type)
   )
generate_grid src max_dist curr_dist curr_y_mod curr_x_mod curr_list =
   if (curr_x_mod > curr_dist)
   then
      if (curr_y_mod > max_dist)
      then
         curr_list
      else
         let
            new_limit = (max_dist - (abs curr_y_mod))
         in
         (generate_grid
            src
            max_dist
            new_limit
            (curr_y_mod + 1)
            (-new_limit)
            curr_list
         )
   else
         (generate_grid
            src
            max_dist
            curr_dist
            curr_y_mod
            (curr_x_mod + 1)
            ({x = (src.x + curr_x_mod), y = (src.y + curr_y_mod)} :: curr_list)
         )

get_closest : (
      Battlemap.Location.Ref ->
      Type ->
      (Battlemap.Location.Ref, Type) ->
      (Battlemap.Location.Ref, Type)
   )
get_closest ref indicator (prev_ref, prev_indicator) =
   if (indicator.distance < prev_indicator.distance)
   then
      (ref, indicator)
   else
      (prev_ref, prev_indicator)

handle_neighbors : (
      Battlemap.Location.Type ->
      Type ->
      (Dict.Dict Battlemap.Location.Ref Type) ->
      (List Battlemap.Direction.Type) ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
handle_neighbors loc indicator remaining directions =
   case (Util.List.pop directions) of
      Nothing -> remaining
      (Just (head, tail)) ->
         let
            neighbor_loc = (Battlemap.Location.neighbor loc head)
            neighbor_indicator =
               (Dict.get
                  (Battlemap.Location.get_ref neighbor_loc)
                  remaining
               )
         in
            case neighbor_indicator of
               Nothing -> (handle_neighbors loc indicator remaining tail)
               (Just neighbor) ->
                  let
                     new_dist = (indicator.distance + neighbor.node_cost)
                  in
                     (handle_neighbors
                        loc
                        indicator
                        (
                           if (new_dist < neighbor.distance)
                           then
                              (Dict.insert
                                 (Battlemap.Location.get_ref neighbor_loc)
                                 {neighbor |
                                    distance = new_dist,
                                    path = (head :: indicator.path)
                                 }
                                 remaining
                              )
                           else
                              remaining
                        )
                        tail
                     )

search : (
      (Dict.Dict Battlemap.Location.Ref Type) ->
      (Dict.Dict Battlemap.Location.Ref Type) ->
      Int ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
search result remaining dist =
   if (Dict.isEmpty remaining)
   then
      result
   else
      let
         (min_loc_ref, min) =
            (Dict.foldl
               (get_closest)
               (
                  (-1,-1),
                  {
                     distance = (dist + 1),
                     path = [],
                     node_cost = 99
                  }
               )
               remaining
            )
      in
         (search
            (Dict.insert min_loc_ref min result)
            (handle_neighbors
               (Battlemap.Location.from_ref min_loc_ref)
               min
               (Dict.remove min_loc_ref remaining)
               [
                  Battlemap.Direction.Left,
                  Battlemap.Direction.Right,
                  Battlemap.Direction.Up,
                  Battlemap.Direction.Down
               ]
            )
            dist
         )

grid_to_range_indicators : (
      Battlemap.Type ->
      Battlemap.Location.Type ->
      Int ->
      (List Battlemap.Location.Type) ->
      (Dict.Dict Battlemap.Location.Ref Type) ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
grid_to_range_indicators battlemap location dist grid result =
   case (Util.List.pop grid) of
      Nothing -> result
      (Just (head, tail)) ->
         if (Battlemap.has_location battlemap head)
         then
            -- TODO: test if the current char can cross that tile.
            -- TODO: get tile cost.
            (grid_to_range_indicators
               battlemap
               location
               dist
               tail
               (Dict.insert
                  (Battlemap.Location.get_ref head)
                  {
                     distance =
                        (
                           if ((location.x == head.x) && (location.y == head.y))
                           then
                              0
                           else
                              (dist + 1)
                        ),
                     path = [],
                     node_cost = 1
                  }
                  result
               )
            )
         else
            (grid_to_range_indicators battlemap location dist tail result)

generate : (
      Battlemap.Type ->
      Battlemap.Location.Type ->
      Int ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
generate battlemap location dist =
   (search
      Dict.empty
      (grid_to_range_indicators
         battlemap
         location
         dist
         (generate_grid location dist 0 (-dist) (-dist) [])
         Dict.empty
      )
      dist
   )
