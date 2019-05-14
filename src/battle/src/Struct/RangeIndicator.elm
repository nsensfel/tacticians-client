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

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Struct.Marker

import Constants.Movement

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias TileData = (Int, Int) -- (TileCost, TileBattles)

-- (TileLocation, TileRequiredBattles)
type alias TileSearchLocation = (BattleMap.Struct.Location.Ref, Int)

type alias Type =
   {
      distance : Int,
      required_battles : Int,
      taxicab_dist : Int,
      atk_range : Int,
      path : (List BattleMap.Struct.Direction.Type),
      marker : Struct.Marker.Type
   }

type alias SearchParameters =
   {
      maximum_distance : Int,
      maximum_attack_range : Int,
      minimum_defense_range : Int,
      tile_data_function : (BattleMap.Struct.Location.Type -> (Int, Int)),
      taxicab_dist_fun : (BattleMap.Struct.Location.Type -> Int)
   }

type alias LocatedIndicator =
   {
      location_ref : BattleMap.Struct.Location.Ref,
      required_battles : Int,
      indicator : Type
   }
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_closest : (
      Int ->
      TileSearchLocation ->
      Type ->
      LocatedIndicator ->
      LocatedIndicator
   )
get_closest max_dist (ref, ignored_param) indicator current_best =
   if (is_closer max_dist indicator current_best.indicator)
   then
      {
         required_battles = indicator.required_battles,
         location_ref = ref,
         indicator = indicator
      }
   else
      current_best

is_closer : Int -> Type -> Type -> Bool
is_closer max_dist candidate current =
   (
      -- It's closer when moving;
      (candidate.distance < current.distance)
      ||
      ( -- Or
         -- neither are reachable by moving,
         (max_dist <= candidate.distance)
         && (max_dist <= current.distance)
         -- but the new one is closer when attacking;
         && (candidate.atk_range < current.atk_range)
      )
   )

generate_neighbor : (
      SearchParameters ->
      BattleMap.Struct.Location.Type ->
      BattleMap.Struct.Direction.Type ->
      Type ->
      (Int, Type)
   )
generate_neighbor search_params neighbor_loc dir src_indicator =
   let
      (node_cost, node_battles) =
         (search_params.tile_data_function neighbor_loc)
      new_dist =
         if (node_cost == Constants.Movement.cost_when_occupied_tile)
         then (search_params.maximum_distance + 1)
         else (src_indicator.distance + node_cost)
      new_atk_range = (src_indicator.atk_range + 1)
      new_taxicab_dist = (search_params.taxicab_dist_fun neighbor_loc)
      new_battle_count = (src_indicator.required_battles + node_battles)
      can_defend = (new_taxicab_dist > search_params.minimum_defense_range)
   in
      if (new_dist > search_params.maximum_distance)
      then
         (
            node_cost,
            {
               distance = (search_params.maximum_distance + 1),
               atk_range = (src_indicator.atk_range + 1),
               taxicab_dist = new_taxicab_dist,
               required_battles = new_battle_count,
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
               required_battles = new_battle_count,
               taxicab_dist = new_taxicab_dist,
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
      BattleMap.Struct.Location.Ref ->
      Type ->
      (Dict.Dict TileSearchLocation Type) ->
      (Dict.Dict TileSearchLocation Type) ->
      Bool
   )
candidate_is_an_improvement
   search_params
   loc_ref
   candidate
   candidate_solutions
   best_solutions =
   (List.all
      -- Does it improve on all possible solutions that have less (or as much)
      -- battles?
      (\req_battles ->
         let index = (loc_ref, req_battles) in
            case (Dict.get index candidate_solutions) of
               (Just alternative) ->
                  (is_closer
                     search_params.maximum_distance
                     candidate
                     alternative
                  )

               Nothing ->
                     case (Dict.get index best_solutions) of
                        (Just alternative) ->
                           (is_closer
                              search_params.maximum_distance
                              candidate
                              alternative
                           )

                        Nothing -> True
      )
      (List.range 0 candidate.required_battles)
   )

handle_neighbors : (
      LocatedIndicator ->
      (Dict.Dict TileSearchLocation Type) ->
      SearchParameters ->
      BattleMap.Struct.Direction.Type ->
      (Dict.Dict TileSearchLocation Type) ->
      (Dict.Dict TileSearchLocation Type)
   )
handle_neighbors src results search_params dir remaining =
   let
      src_loc = (BattleMap.Struct.Location.from_ref src.location_ref)
      neighbor_loc = (BattleMap.Struct.Location.neighbor dir src_loc)
      neighbor_loc_ref = (BattleMap.Struct.Location.get_ref neighbor_loc)
      (candidate_cost, candidate) =
         (generate_neighbor search_params neighbor_loc dir src.indicator)
      candidate_index = (neighbor_loc_ref, candidate.required_battles)
   in
      if
      (
         (candidate_is_acceptable search_params candidate_cost candidate)
         &&
         (candidate_is_an_improvement
            search_params
            neighbor_loc_ref
            candidate
            remaining
            results
         )
      )
      then (Dict.insert candidate_index candidate remaining)
      else remaining

find_closest_in : (
      SearchParameters ->
      (Dict.Dict TileSearchLocation Type) ->
      LocatedIndicator
   )
find_closest_in search_params remaining =
   (Dict.foldl
      (get_closest search_params.maximum_distance)
      {
         required_battles = 9999,
         location_ref = (-1, -1),
         indicator =
            {
               required_battles = 9999,
               distance = Constants.Movement.cost_when_out_of_bounds,
               path = [],
               atk_range = Constants.Movement.cost_when_out_of_bounds,
               taxicab_dist = Constants.Movement.cost_when_out_of_bounds,
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
               (indicator.taxicab_dist <= search_params.minimum_defense_range)
            )
         of
            (True, True) -> Struct.Marker.CanAttackCantDefend
            (True, False) -> Struct.Marker.CanAttackCanDefend
            (False, True) -> Struct.Marker.CanGoToCantDefend
            (False, False) -> Struct.Marker.CanGoToCanDefend
   }

insert_in_dictionary : (
      LocatedIndicator ->
      (Dict.Dict TileSearchLocation Type) ->
      (Dict.Dict TileSearchLocation Type)
   )
insert_in_dictionary located_indicator dict =
   (Dict.insert
      (located_indicator.location_ref, located_indicator.required_battles)
      located_indicator.indicator
      dict
   )

search : (
      (Dict.Dict TileSearchLocation Type) ->
      (Dict.Dict TileSearchLocation Type) ->
      SearchParameters ->
      (Dict.Dict TileSearchLocation Type)
   )
search result remaining search_params =
   if (Dict.isEmpty remaining)
   then result
   else
      let
         closest_located_indicator = (find_closest_in search_params remaining)
         finalized_clos_loc_ind =
            {closest_located_indicator |
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
               (Dict.remove
                  (
                     finalized_clos_loc_ind.location_ref,
                     finalized_clos_loc_ind.required_battles
                  )
                  remaining
               )
               [
                  BattleMap.Struct.Direction.Left,
                  BattleMap.Struct.Direction.Right,
                  BattleMap.Struct.Direction.Up,
                  BattleMap.Struct.Direction.Down
               ]
            )
            search_params
         )

cleanup : (
      (Dict.Dict TileSearchLocation Type) ->
      (Dict.Dict BattleMap.Struct.Location.Ref Type)
   )
cleanup search_results =
   (Dict.foldl
      (\
         (candidate_location, candidate_battles) candidate result ->
            case (Dict.get candidate_location result) of
               (Just current_best) ->
                  if (current_best.required_battles < candidate_battles)
                  then result
                  else (Dict.insert candidate_location candidate result)

               Nothing -> (Dict.insert candidate_location candidate result)
      )
      (Dict.empty)
      search_results
   )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
generate : (
      BattleMap.Struct.Location.Type ->
      Int ->
      Int ->
      Int ->
      (BattleMap.Struct.Location.Type -> (Int, Int)) ->
      (Dict.Dict BattleMap.Struct.Location.Ref Type)
   )
generate location max_dist def_range atk_range tile_data_fun =
   (cleanup
      (search
         Dict.empty
         (Dict.insert
            ((BattleMap.Struct.Location.get_ref location), 0)
            {
               distance = 0,
               path = [],
               atk_range = 0,
               taxicab_dist = 0,
               required_battles = 0,
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
            tile_data_function = (tile_data_fun),
            taxicab_dist_fun = (BattleMap.Struct.Location.dist location)
         }
      )
   )

get_marker : Type -> Struct.Marker.Type
get_marker indicator = indicator.marker

get_path : Type -> (List BattleMap.Struct.Direction.Type)
get_path indicator = indicator.path
