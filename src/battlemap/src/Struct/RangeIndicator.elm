module Struct.RangeIndicator exposing
   (
      Type,
      generate,
      get_marker,
      get_path
   )

-- FIXME: This module is still too much of a mess...

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
      true_range: Int,
      atk_range: Int,
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
         && (indicator.atk_range < prev_indicator.atk_range)
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
         && (new_range < neighbor.atk_range)
      )
   )


handle_neighbors : (
      Type ->
      Struct.Location.Type ->
      Int ->
      Int ->
      Int ->
      (Dict.Dict Struct.Location.Ref Type) ->
      (Struct.Location.Type -> Int) ->
      Struct.Direction.Type ->
      (Dict.Dict Struct.Location.Ref Type) ->
      (Dict.Dict Struct.Location.Ref Type)
   )
handle_neighbors
   src_indicator src_loc
   dist
   atk_range def_range
   results cost_fun dir rem =
   let
      neighbor_loc = (Struct.Location.neighbor dir src_loc)
   in
      case (Dict.get (Struct.Location.get_ref neighbor_loc) results) of
         (Just _) -> rem

         Nothing ->
            let
               node_cost = (cost_fun neighbor_loc)
               new_dist = (src_indicator.distance + node_cost)
               new_atk_range = (src_indicator.atk_range + 1)
               new_true_range = (src_indicator.true_range + 1)
               can_defend = (new_true_range >= def_range)
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
                              (is_closer new_dist new_atk_range neighbor)

                           Nothing ->
                              True
                     )
                     &&
                     (node_cost /= Constants.Movement.cost_when_out_of_bounds)
                     &&
                     (
                        (new_dist <= dist)
                        ||
                        (new_atk_range <= atk_range)
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
                              atk_range = new_atk_range,
                              true_range = new_true_range,
                              path = (dir :: src_indicator.path),
                              marker =
                                 if (can_defend)
                                 then
                                    Struct.Marker.CanAttackCanDefend
                                 else
                                    Struct.Marker.CanAttackCantDefend
                           }
                        else
                           {
                              distance = new_dist,
                              atk_range = 0,
                              true_range = new_true_range,
                              path = (dir :: src_indicator.path),
                              marker =
                                 if (can_defend)
                                 then
                                    Struct.Marker.CanGoToCanDefend
                                 else
                                    Struct.Marker.CanGoToCantDefend
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
                     atk_range = Constants.Movement.cost_when_out_of_bounds,
                     true_range = Constants.Movement.cost_when_out_of_bounds,
                     marker = Struct.Marker.CanAttackCanDefend
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
                     case
                        ((min.atk_range > 0), (min.true_range <= def_range))
                     of
                        (True, True) -> Struct.Marker.CanAttackCantDefend
                        (True, False) -> Struct.Marker.CanAttackCanDefend
                        (False, True) -> Struct.Marker.CanGoToCantDefend
                        (False, False) -> Struct.Marker.CanGoToCanDefend
               }
               result
            )
            (List.foldl
               (handle_neighbors
                  min
                  (Struct.Location.from_ref min_loc_ref)
                  dist
                  atk_range
                  def_range
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
            atk_range = 0,
            true_range = 0,
            marker =
               if (def_range == 0)
               then
                  Struct.Marker.CanGoToCanDefend
               else
                  Struct.Marker.CanGoToCantDefend
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
