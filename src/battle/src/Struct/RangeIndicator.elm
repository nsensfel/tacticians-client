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

-- Map -------------------------------------------------------------------
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

type alias SearchParameters =
   {
      maximum_distance: Int,
      maximum_attack_range: Int,
      minimum_defense_range: Int,
      cost_function: (Struct.Location.Type -> Int),
      true_range_fun: (Struct.Location.Type -> Int)
   }

type alias LocatedIndicator =
   {
      location_ref: Struct.Location.Ref,
      indicator: Type
   }
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_closest : (
      Int ->
      Struct.Location.Ref ->
      Type ->
      LocatedIndicator ->
      LocatedIndicator
   )
get_closest max_dist ref indicator current_best =
   if (is_closer max_dist indicator current_best.indicator)
   then
      {
         location_ref = ref,
         indicator = indicator
      }
   else
      current_best

is_closer : Int -> Type -> Type -> Bool
is_closer max_dist candidate current =
   (
      -- It's closer when moving
      (candidate.distance < current.distance)
      ||
      (
         -- Or neither are reachable by moving,
         (max_dist <= candidate.distance)
         && (max_dist <= current.distance)
         -- but the new one is closer when attacking.
         && (candidate.atk_range < current.atk_range)
      )
   )

generate_neighbor : (
      SearchParameters ->
      Struct.Location.Type ->
      Struct.Direction.Type ->
      Type ->
      (Int, Type)
   )
generate_neighbor search_params neighbor_loc dir src_indicator =
   let
      node_cost = (search_params.cost_function neighbor_loc)
      new_dist =
         if (node_cost == Constants.Movement.cost_when_occupied_tile)
         then
            (search_params.maximum_distance + 1)
         else
            (src_indicator.distance + node_cost)
      new_atk_range = (src_indicator.atk_range + 1)
      new_true_range = (search_params.true_range_fun neighbor_loc)
      can_defend = (new_true_range > search_params.minimum_defense_range)
   in
      if (new_dist > search_params.maximum_distance)
      then
         (
            node_cost,
            {
               distance = (search_params.maximum_distance + 1),
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
         )
      else
         (
            node_cost,
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

candidate_is_acceptable : (SearchParameters -> Int -> Type -> Bool)
candidate_is_acceptable search_params cost candidate =
   (
      (cost /= Constants.Movement.cost_when_out_of_bounds)
      &&
      (
         (candidate.distance <= search_params.maximum_distance)
         || (candidate.atk_range <= search_params.maximum_attack_range)
      )
   )

candidate_is_an_improvement : (
      SearchParameters ->
      Struct.Location.Ref ->
      Type ->
      (Dict.Dict Struct.Location.Ref Type) ->
      Bool
   )
candidate_is_an_improvement search_params loc_ref candidate alternatives =
   case (Dict.get loc_ref alternatives) of
      (Just alternative) ->
         (is_closer search_params.maximum_distance candidate alternative)

      Nothing ->
         True

handle_neighbors : (
      LocatedIndicator ->
      (Dict.Dict Struct.Location.Ref Type) ->
      SearchParameters ->
      Struct.Direction.Type ->
      (Dict.Dict Struct.Location.Ref Type) ->
      (Dict.Dict Struct.Location.Ref Type)
   )
handle_neighbors src results search_params dir remaining =
   let
      src_loc = (Struct.Location.from_ref src.location_ref)
      neighbor_loc = (Struct.Location.neighbor dir src_loc)
      neighbor_loc_ref = (Struct.Location.get_ref neighbor_loc)
   in
      case (Dict.get neighbor_loc_ref results) of
         (Just _) ->
            -- A minimal path for this location has already been found
            remaining

         Nothing ->
            let
               (candidate_cost, candidate) =
                  (generate_neighbor
                     search_params
                     neighbor_loc
                     dir
                     src.indicator
                  )
            in
               if
               (
                  (candidate_is_acceptable
                     search_params
                     candidate_cost
                     candidate
                  )
                  &&
                  (candidate_is_an_improvement
                     search_params
                     neighbor_loc_ref
                     candidate
                     remaining
                  )
               )
               then
                  (Dict.insert neighbor_loc_ref candidate remaining)
               else
                  remaining

find_closest_in : (
      SearchParameters ->
      (Dict.Dict Struct.Location.Ref Type) ->
      LocatedIndicator
   )
find_closest_in search_params remaining =
   (Dict.foldl
      (get_closest search_params.maximum_distance)
      {
         location_ref = (-1, -1),
         indicator =
            {
               distance = Constants.Movement.cost_when_out_of_bounds,
               path = [],
               atk_range = Constants.Movement.cost_when_out_of_bounds,
               true_range = Constants.Movement.cost_when_out_of_bounds,
               marker = Struct.Marker.CanAttackCanDefend
            }
      }
      remaining
   )

resolve_marker_type : SearchParameters -> Type -> Type
resolve_marker_type search_params indicator =
   {indicator |
      marker =
         case
            (
               (indicator.atk_range > 0),
               (indicator.true_range <= search_params.minimum_defense_range)
            )
         of
            (True, True) -> Struct.Marker.CanAttackCantDefend
            (True, False) -> Struct.Marker.CanAttackCanDefend
            (False, True) -> Struct.Marker.CanGoToCantDefend
            (False, False) -> Struct.Marker.CanGoToCanDefend
   }

insert_in_dictionary : (
      LocatedIndicator ->
      (Dict.Dict Struct.Location.Ref Type) ->
      (Dict.Dict Struct.Location.Ref Type)
   )
insert_in_dictionary located_indicator dict =
   (Dict.insert
      located_indicator.location_ref
      located_indicator.indicator
      dict
   )

search : (
      (Dict.Dict Struct.Location.Ref Type) ->
      (Dict.Dict Struct.Location.Ref Type) ->
      SearchParameters ->
      (Dict.Dict Struct.Location.Ref Type)
   )
search result remaining search_params =
   if (Dict.isEmpty remaining)
   then
      result
   else
      let
         closest_located_indicator = (find_closest_in search_params remaining)
         finalized_clos_loc_ind =
            {closest_located_indicator|
               indicator =
                  (resolve_marker_type
                     search_params
                     closest_located_indicator.indicator
                  )
            }
      in
         (search
            (insert_in_dictionary finalized_clos_loc_ind result)
            (List.foldl
               (handle_neighbors
                  finalized_clos_loc_ind
                  result
                  search_params
               )
               (Dict.remove finalized_clos_loc_ind.location_ref remaining)
               [
                  Struct.Direction.Left,
                  Struct.Direction.Right,
                  Struct.Direction.Up,
                  Struct.Direction.Down
               ]
            )
            search_params
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
generate location max_dist def_range atk_range cost_fun =
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
      {
         maximum_distance = max_dist,
         maximum_attack_range = atk_range,
         minimum_defense_range = def_range,
         cost_function = (cost_fun),
         true_range_fun = (Struct.Location.dist location)
      }
   )

get_marker : Type -> Struct.Marker.Type
get_marker indicator = indicator.marker

get_path : Type -> (List Struct.Direction.Type)
get_path indicator = indicator.path
