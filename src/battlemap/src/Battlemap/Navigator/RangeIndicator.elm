module Battlemap.Navigator.RangeIndicator exposing
   (
      Type,
      generate,
      get_marker,
      get_path
   )

import Dict
import List

import Battlemap.Direction
import Battlemap.Location
import Battlemap.Marker

import Util.List

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      distance: Int,
      path: (List Battlemap.Direction.Type),
      node_cost: Int,
      marker: Battlemap.Marker.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
generate_row : (
      Battlemap.Location.Type ->
      Int ->
      Int ->
      Int ->
      (List Battlemap.Location.Type) ->
      (List Battlemap.Location.Type)
   )
generate_row src max_x_mod curr_y curr_x_mod curr_row =
   if (curr_x_mod > max_x_mod)
   then
      curr_row
   else
      (generate_row
         src
         max_x_mod
         curr_y
         (curr_x_mod + 1)
         ({x = (src.x + curr_x_mod), y = curr_y} :: curr_row)
      )

generate_grid : (
      Battlemap.Location.Type ->
      Int ->
      Int ->
      (List Battlemap.Location.Type) ->
      (List Battlemap.Location.Type)
   )
generate_grid src dist curr_y_mod curr_list =
   if (curr_y_mod > dist)
   then
      curr_list
   else
      let
         new_limit = (dist - (abs curr_y_mod))
      in
         (generate_grid
            src
            dist
            (curr_y_mod + 1)
            (
               (generate_row
                  src
                  new_limit
                  (src.y + curr_y_mod)
                  (-new_limit)
                  []
               )
               ++ curr_list
            )
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
      Int ->
      Int ->
      Type ->
      (Dict.Dict Battlemap.Location.Ref Type) ->
      (List Battlemap.Direction.Type) ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
handle_neighbors loc dist atk_dist indicator remaining directions =
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
               Nothing ->
                  (handle_neighbors
                     loc
                     dist
                     atk_dist
                     indicator
                     remaining
                     tail
                  )
               (Just neighbor) ->
                  let
                     new_dist = (indicator.distance + neighbor.node_cost)
                  in
                     (handle_neighbors
                        loc
                        dist
                        atk_dist
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
      Int ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
search result remaining dist atk_dist =
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
                     distance = 999999,
                     path = [],
                     node_cost = 999999,
                     marker = Battlemap.Marker.CanAttack
                  }
               )
               remaining
            )
      in
         (search
            (Dict.insert
               min_loc_ref
               {min |
                  marker =
                     (
                        if (min.distance > dist)
                        then
                           Battlemap.Marker.CanAttack
                        else
                           Battlemap.Marker.CanGoTo
                     )
               }
               result
            )
            (handle_neighbors
               (Battlemap.Location.from_ref min_loc_ref)
               dist
               atk_dist
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
            atk_dist
         )

grid_to_range_indicators : (
      (Battlemap.Location.Type -> Bool) ->
      (Battlemap.Location.Type -> Int) ->
      Battlemap.Location.Type ->
      (List Battlemap.Location.Type) ->
      (Dict.Dict Battlemap.Location.Ref Type) ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
grid_to_range_indicators can_cross_fun cost_fun location grid result =
   case (Util.List.pop grid) of
      Nothing -> result
      (Just (head, tail)) ->
         if (can_cross_fun head)
         then
            (grid_to_range_indicators
               (can_cross_fun)
               (cost_fun)
               location
               tail
               (Dict.insert
                  (Battlemap.Location.get_ref head)
                  {
                     distance =
                        (
                           if
                              (
                                 (location.x == head.x)
                                 && (location.y == head.y)
                              )
                           then
                              0
                           else
                              9999
                        ),
                     path = [],
                     node_cost = (cost_fun head),
                     marker = Battlemap.Marker.CanGoTo
                  }
                  result
               )
            )
         else
            (grid_to_range_indicators
               (can_cross_fun)
               (cost_fun)
               location
               tail
               result
            )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
generate : (
      Battlemap.Location.Type ->
      Int ->
      Int ->
      (Battlemap.Location.Type -> Bool) ->
      (Battlemap.Location.Type -> Int) ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
generate location dist atk_dist can_cross_fun cost_fun =
   (Dict.filter
      (\loc_ref range_indicator ->
         (range_indicator.distance <= atk_dist)
      )
      (search
         Dict.empty
         (grid_to_range_indicators
            (can_cross_fun)
            (cost_fun)
            location
            (generate_grid location atk_dist (-atk_dist) [])
            Dict.empty
         )
         dist
         atk_dist
      )
   )

get_marker : Type -> Battlemap.Marker.Type
get_marker indicator = indicator.marker

get_path : Type -> (List Battlemap.Direction.Type)
get_path indicator = indicator.path
