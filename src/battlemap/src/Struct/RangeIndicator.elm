module Struct.RangeIndicator exposing
   (
      Type,
      generate,
      get_marker,
      get_path
   )

-- Elm -------------------------------------------------------------------------
import Dict
import List

-- Battlemap -------------------------------------------------------------------
import Struct.Direction
import Struct.Location
import Struct.Marker

import Constants.Movement

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      distance: Int,
      range: Int,
      path: (List Struct.Direction.Type),
      marker: Struct.Marker.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_closest : (
      Int ->
      Struct.Location.Ref ->
      Type ->
      (Struct.Location.Ref, Type) ->
      (Struct.Location.Ref, Type)
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
      Struct.Location.Type ->
      Int ->
      Int ->
      (Dict.Dict Struct.Location.Ref Type) ->
      (Struct.Location.Type -> Int) ->
      Struct.Direction.Type ->
      (Dict.Dict Struct.Location.Ref Type) ->
      (Dict.Dict Struct.Location.Ref Type)
   )
handle_neighbors src_indicator src_loc dist range results cost_fun dir rem =
   let
      neighbor_loc = (Struct.Location.neighbor src_loc dir)
   in
      case (Dict.get (Struct.Location.get_ref neighbor_loc) results) of
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
                              (Struct.Location.get_ref neighbor_loc)
                              rem
                           )
                        of
                           (Just neighbor) ->
                              (is_closer new_dist new_range neighbor)

                           Nothing ->
                              True
                     )
                     &&
                     (node_cost /= Constants.Movement.cost_when_out_of_bounds)
                     &&
                     (
                        (new_dist <= dist)
                        ||
                        (new_range <= range)
                     )
                  )
               then
                  (Dict.insert
                     (Struct.Location.get_ref neighbor_loc)
                     (
                        if (new_dist > dist)
                        then
                           {
                              distance = (dist + 1),
                              range = new_range,
                              path = (dir :: src_indicator.path),
                              marker = Struct.Marker.CanAttack
                           }
                        else
                           {
                              distance = new_dist,
                              range = 0,
                              path = (dir :: src_indicator.path),
                              marker = Struct.Marker.CanGoTo
                           }
                     )
                     rem
                  )
               else
                  rem

search : (
      (Dict.Dict Struct.Location.Ref Type) ->
      (Dict.Dict Struct.Location.Ref Type) ->
      Int ->
      Int ->
      Int ->
      (Struct.Location.Type -> Int) ->
      (Dict.Dict Struct.Location.Ref Type)
   )
search result remaining dist atk_range def_range cost_fun =
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
                     marker = Struct.Marker.CanAttack
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
                           if (min.range <= def_range)
                           then
                              Struct.Marker.CantDefend
                           else
                              Struct.Marker.CanAttack
                        else
                           Struct.Marker.CanGoTo
                     )
               }
               result
            )
            (List.foldl
               (handle_neighbors
                  min
                  (Struct.Location.from_ref min_loc_ref)
                  dist
                  atk_range
                  result
                  (cost_fun)
               )
               (Dict.remove min_loc_ref remaining)
               [
                  Struct.Direction.Left,
                  Struct.Direction.Right,
                  Struct.Direction.Up,
                  Struct.Direction.Down
               ]
            )
            dist
            atk_range
            def_range
            (cost_fun)
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
generate : (
      Struct.Location.Type ->
      Int ->
      Int ->
      Int ->
      (Struct.Location.Type -> Int) ->
      (Dict.Dict Struct.Location.Ref Type)
   )
generate location dist atk_range def_range cost_fun =
   (search
      Dict.empty
      (Dict.insert
         (Struct.Location.get_ref location)
         {
            distance = 0,
            path = [],
            range = 0,
            marker = Struct.Marker.CanGoTo
         }
         Dict.empty
      )
      dist
      atk_range
      def_range
      (cost_fun)
   )

get_marker : Type -> Struct.Marker.Type
get_marker indicator = indicator.marker

get_path : Type -> (List Struct.Direction.Type)
get_path indicator = indicator.path
