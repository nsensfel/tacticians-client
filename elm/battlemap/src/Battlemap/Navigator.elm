module Battlemap.Navigator exposing
   (
      Type,
      new,
      get_current_location,
      get_remaining_points,
      get_range_markers,
      try_adding_step,
      try_getting_path_to
   )

import Dict

import Battlemap.Location
import Battlemap.Direction

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
      (Battlemap.Location.Type -> Bool) -> Type
   )
new start_loc mov_dist atk_dist can_cross_fun =
   {
      starting_location = start_loc,
      movement_dist = mov_dist,
      attack_dist = atk_dist,
      path = (Battlemap.Navigator.Path.new start_loc mov_dist),
      range_indicators =
         (Battlemap.Navigator.RangeIndicator.generate
            start_loc
            mov_dist
            atk_dist
            (can_cross_fun)
         )
   }

get_current_location : Type -> Battlemap.Location.Type
get_current_location navigator =
   (Battlemap.Navigator.Path.get_current_location navigator.path)

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

try_adding_step : (
      Type ->
      Battlemap.Direction.Type ->
      (Battlemap.Location.Type -> Bool) ->
      (Battlemap.Location.Type -> Int) ->
      (Maybe Type)
   )
try_adding_step navigator dir can_cross cost_fun =
   case
      (Battlemap.Navigator.Path.try_following_direction
         can_cross
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
