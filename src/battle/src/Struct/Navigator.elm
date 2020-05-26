module Struct.Navigator exposing
   (
      Type,
      Summary,
      new,
      get_current_location,
      get_starting_location,
      get_remaining_points,
      get_range_markers,
      get_path,
      get_summary,
      clear_path,
      lock_path,
      lock_path_with_new_attack_ranges,
      unlock_path,
      maybe_add_step,
      maybe_get_path_to
   )

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Direction

-- Local Module ----------------------------------------------------------------
import Struct.Marker
import Struct.Path
import Struct.RangeIndicator

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      starting_location : BattleMap.Struct.Location.Type,
      movement_dist : Int,
      defense_dist : Int,
      attack_dist : Int,
      path : Struct.Path.Type,
      locked_path : Bool,
      range_indicators :
         (Dict.Dict
            BattleMap.Struct.Location.Ref
            Struct.RangeIndicator.Type
         ),
      cost_and_danger_fun : (BattleMap.Struct.Location.Type -> (Int, Int))
   }

type alias Summary =
   {
      starting_location : BattleMap.Struct.Location.Type,
      path : (List BattleMap.Struct.Direction.Type),
      markers : (List (BattleMap.Struct.Location.Ref, Struct.Marker.Type)),
      locked_path : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : (
      BattleMap.Struct.Location.Type ->
      Int ->
      Int ->
      Int ->
      (BattleMap.Struct.Location.Type -> (Int, Int)) ->
      Type
   )
new start_loc mov_dist def_dist atk_dist cost_and_danger_fun =
   {
      starting_location = start_loc,
      movement_dist = mov_dist,
      attack_dist = atk_dist,
      defense_dist = def_dist,
      path = (Struct.Path.new start_loc mov_dist),
      locked_path = False,
      range_indicators =
         (Struct.RangeIndicator.generate
            start_loc
            mov_dist
            def_dist
            atk_dist
            (cost_and_danger_fun)
         ),
      cost_and_danger_fun = cost_and_danger_fun
   }

get_current_location : Type -> BattleMap.Struct.Location.Type
get_current_location navigator =
   (Struct.Path.get_current_location navigator.path)

get_starting_location : Type -> BattleMap.Struct.Location.Type
get_starting_location navigator = navigator.starting_location

get_remaining_points : Type -> Int
get_remaining_points navigator =
    (Struct.Path.get_remaining_points navigator.path)

get_range_markers : (
      Type ->
      (List
         (BattleMap.Struct.Location.Ref, Struct.RangeIndicator.Type)
      )
   )
get_range_markers navigator = (Dict.toList navigator.range_indicators)

get_path : Type -> (List BattleMap.Struct.Direction.Type)
get_path navigator = (Struct.Path.get_summary navigator.path)

get_summary : Type -> Summary
get_summary navigator =
   {
      starting_location = navigator.starting_location,
      path = (Struct.Path.get_summary navigator.path),
      markers =
         (List.map
            (\(loc, range_indicator) ->
               (
                  loc,
                  (Struct.RangeIndicator.get_marker
                     range_indicator
                  )
               )
            )
            (Dict.toList
               navigator.range_indicators
            )
         ),
      locked_path = navigator.locked_path
   }

clear_path : Type -> Type
clear_path navigator =
   if (navigator.locked_path)
   then
      navigator
   else
      {navigator |
         path =
            (Struct.Path.new
               navigator.starting_location
               navigator.movement_dist
            )
      }

lock_path : Type -> Type
lock_path navigator =
   {navigator |
      range_indicators =
         (Struct.RangeIndicator.generate
            (Struct.Path.get_current_location navigator.path)
            0
            navigator.defense_dist
            navigator.attack_dist
            (navigator.cost_and_danger_fun)
         ),
      locked_path = True
   }

unlock_path : Type -> Type
unlock_path navigator =
   {navigator |
      range_indicators =
         (Struct.RangeIndicator.generate
            navigator.starting_location
            navigator.movement_dist
            navigator.defense_dist
            navigator.attack_dist
            (navigator.cost_and_danger_fun)
         ),
      locked_path = True
   }

lock_path_with_new_attack_ranges : Int -> Int -> Type -> Type
lock_path_with_new_attack_ranges range_min range_max navigator =
   {navigator |
      range_indicators =
         (Struct.RangeIndicator.generate
            (Struct.Path.get_current_location navigator.path)
            0
            range_min
            range_max
            (navigator.cost_and_danger_fun)
         ),
      locked_path = True
   }

maybe_add_step : (
      BattleMap.Struct.Direction.Type ->
      Type ->
      (Maybe Type)
   )
maybe_add_step dir navigator =
   if (navigator.locked_path)
   then
      Nothing
   else
      case
         (Struct.Path.maybe_add_step
            dir
            (navigator.cost_and_danger_fun)
            navigator.path
         )
      of
         (Just path) -> (Just {navigator | path = path})
         Nothing -> Nothing

maybe_get_path_to : (
      BattleMap.Struct.Location.Ref ->
      Type ->
      (Maybe (List BattleMap.Struct.Direction.Type))
   )
maybe_get_path_to loc_ref navigator =
   case (Dict.get loc_ref navigator.range_indicators) of
      (Just target) ->
         (Just (Struct.RangeIndicator.get_path target))

      Nothing -> Nothing

