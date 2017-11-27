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

import Constants.Movement

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      distance: Int,
      range: Int,
      path: (List Battlemap.Direction.Type),
      marker: Battlemap.Marker.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_closest : (
      Int ->
      Battlemap.Location.Ref ->
      Type ->
      (Battlemap.Location.Ref, Type) ->
      (Battlemap.Location.Ref, Type)
   )
get_closest dist ref indicator (prev_ref, prev_indicator) =
   if
   (
      (indicator.distance < prev_indicator.distance)
      ||
      (
         (indicator.distance > dist)
         && (prev_indicator.distance > dist)
         && (indicator.range < prev_indicator.range)
      )
   )
   then
      (ref, indicator)
   else
      (prev_ref, prev_indicator)

is_closer : Int -> Int -> Type -> Bool
is_closer new_dist new_range neighbor =
   (
      (new_dist < neighbor.distance)
      ||
      (
         (neighbor.distance > new_dist)
         && (new_range < neighbor.range)
      )
   )


handle_neighbors : (
      Type ->
      Battlemap.Location.Type ->
      Int ->
      Int ->
      (Dict.Dict Battlemap.Location.Ref Type) ->
      (Battlemap.Location.Type -> Int) ->
      Battlemap.Direction.Type ->
      (Dict.Dict Battlemap.Location.Ref Type) ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
handle_neighbors src_indicator src_loc dist range results cost_fun dir rem =
   let
      neighbor_loc = (Battlemap.Location.neighbor src_loc dir)
   in
      case (Dict.get (Battlemap.Location.get_ref neighbor_loc) results) of
         (Just _) -> rem

         Nothing ->
            let
               node_cost = (cost_fun neighbor_loc)
               new_dist = (src_indicator.distance + node_cost)
               new_range = (src_indicator.range + 1)
            in
               if
                  (
                     (
                        case
                           (Dict.get
                              (Battlemap.Location.get_ref neighbor_loc)
                              rem
                           )
                        of
                           (Just neighbor) ->
                              (is_closer new_dist new_range neighbor)

                           Nothing ->
                              True
                     )
                     &&
                     (
                        (new_dist <= dist)
                        ||
                        (new_range <= range)
                     )
                  )
               then
                  (Dict.insert
                     (Battlemap.Location.get_ref neighbor_loc)
                     (
                        if (new_dist > dist)
                        then
                           {
                              distance = (dist + 1),
                              range = new_range,
                              path = (dir :: src_indicator.path),
                              marker = Battlemap.Marker.CanAttack
                           }
                        else
                           {
                              distance = new_dist,
                              range = 0,
                              path = (dir :: src_indicator.path),
                              marker = Battlemap.Marker.CanGoTo
                           }
                     )
                     rem
                  )
               else
                  rem

search : (
      (Dict.Dict Battlemap.Location.Ref Type) ->
      (Dict.Dict Battlemap.Location.Ref Type) ->
      Int ->
      Int ->
      (Battlemap.Location.Type -> Int) ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
search result remaining dist range cost_fun =
   if (Dict.isEmpty remaining)
   then
      result
   else
      let
         (min_loc_ref, min) =
            (Dict.foldl
               (get_closest dist)
               (
                  (-1,-1),
                  {
                     distance = Constants.Movement.cost_when_out_of_bounds,
                     path = [],
                     range = Constants.Movement.cost_when_out_of_bounds,
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
                        if (min.range > 0)
                        then
                           Battlemap.Marker.CanAttack
                        else
                           Battlemap.Marker.CanGoTo
                     )
               }
               result
            )
            (List.foldl
               (handle_neighbors
                  min
                  (Battlemap.Location.from_ref min_loc_ref)
                  dist
                  range
                  result
                  (cost_fun)
               )
               (Dict.remove min_loc_ref remaining)
               [
                  Battlemap.Direction.Left,
                  Battlemap.Direction.Right,
                  Battlemap.Direction.Up,
                  Battlemap.Direction.Down
               ]
            )
            dist
            range
            (cost_fun)
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
generate : (
      Battlemap.Location.Type ->
      Int ->
      Int ->
      (Battlemap.Location.Type -> Int) ->
      (Dict.Dict Battlemap.Location.Ref Type)
   )
generate location dist range cost_fun =
   (search
      Dict.empty
      (Dict.insert
         (Battlemap.Location.get_ref location)
         {
            distance = 0,
            path = [],
            range = 0,
            marker = Battlemap.Marker.CanGoTo
         }
         Dict.empty
      )
      dist
      range
      (cost_fun)
   )

get_marker : Type -> Battlemap.Marker.Type
get_marker indicator = indicator.marker

get_path : Type -> (List Battlemap.Direction.Type)
get_path indicator = indicator.path
