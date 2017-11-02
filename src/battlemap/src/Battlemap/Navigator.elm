module Battlemap.Navigator exposing
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
      try_adding_step,
      try_getting_path_to
   )

import Dict

import Battlemap.Location
import Battlemap.Direction
import Battlemap.Marker

import Battlemap.Navigator.Path
import Battlemap.Navigator.RangeIndicator

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      starting_location: Battlemap.Location.Type,
      movement_dist: Int,
      attack_dist: Int,
      path: Battlemap.Navigator.Path.Type,
      range_indicators:
         (Dict.Dict
            Battlemap.Location.Ref
            Battlemap.Navigator.RangeIndicator.Type
         )
   }

type alias Summary =
   {
      starting_location: Battlemap.Location.Type,
      path: (List Battlemap.Direction.Type),
      markers: (List (Battlemap.Location.Ref, Battlemap.Marker.Type))
   }
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------

new : (
      Battlemap.Location.Type ->
      Int ->
      Int ->
      (Battlemap.Location.Type -> Int) ->
      Type
   )
new start_loc mov_dist atk_dist cost_fun =
   {
      starting_location = start_loc,
      movement_dist = mov_dist,
      attack_dist = atk_dist,
      path = (Battlemap.Navigator.Path.new start_loc mov_dist),
      range_indicators =
         (Battlemap.Navigator.RangeIndicator.generate
            start_loc
            mov_dist
            (mov_dist + atk_dist)
            (cost_fun)
         )
   }

get_current_location : Type -> Battlemap.Location.Type
get_current_location navigator =
   (Battlemap.Navigator.Path.get_current_location navigator.path)

get_starting_location : Type -> Battlemap.Location.Type
get_starting_location navigator = navigator.starting_location

get_remaining_points : Type -> Int
get_remaining_points navigator =
    (Battlemap.Navigator.Path.get_remaining_points navigator.path)

get_range_markers : (
      Type ->
      (List
         (Battlemap.Location.Ref, Battlemap.Navigator.RangeIndicator.Type)
      )
   )
get_range_markers navigator = (Dict.toList navigator.range_indicators)

get_path : Type -> (List Battlemap.Direction.Type)
get_path navigator = (Battlemap.Navigator.Path.get_summary navigator.path)

get_summary : Type -> Summary
get_summary navigator =
   {
      starting_location = navigator.starting_location,
      path = (Battlemap.Navigator.Path.get_summary navigator.path),
      markers =
         (List.map
            (\(loc, range_indicator) ->
               (
                  loc,
                  (Battlemap.Navigator.RangeIndicator.get_marker
                     range_indicator
                  )
               )
            )
            (Dict.toList
               navigator.range_indicators
            )
         )
   }

clear_path : Type -> Type
clear_path navigator =
   {navigator |
      path =
         (Battlemap.Navigator.Path.new
            navigator.starting_location
            navigator.movement_dist
         )
   }

try_adding_step : (
      Type ->
      Battlemap.Direction.Type ->
      (Battlemap.Location.Type -> Int) ->
      (Maybe Type)
   )
try_adding_step navigator dir cost_fun =
   case
      (Battlemap.Navigator.Path.try_following_direction
         cost_fun
         (Just navigator.path)
         dir
      )
   of
      (Just path) -> (Just {navigator | path = path})
      Nothing -> Nothing

try_getting_path_to : (
      Type ->
      Battlemap.Location.Ref ->
      (Maybe (List Battlemap.Direction.Type))
   )
try_getting_path_to navigator loc_ref =
   case (Dict.get loc_ref navigator.range_indicators) of
      (Just target) ->
         (Just (Battlemap.Navigator.RangeIndicator.get_path target))
      Nothing -> Nothing

