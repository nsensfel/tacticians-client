module Battlemap exposing
   (
      Type,
      reset,
      get_navigator_location,
      get_navigator_remaining_points,
      set_navigator,
      add_step_to_navigator
   )

import Array

import Battlemap.Navigator
import Battlemap.Navigator.RangeIndicator
import Battlemap.Tile
import Battlemap.Direction
import Battlemap.Location

import Util.Array
--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      width: Int,
      height: Int,
      content: (Array.Array Battlemap.Tile.Type),
      navigator: (Maybe Battlemap.Navigator.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
location_to_index : Type -> Battlemap.Location.Type -> Int
location_to_index bmap loc =
   ((loc.y * bmap.width) + loc.x)

has_location : Type -> Battlemap.Location.Type -> Bool
has_location bmap loc =
   (
      (loc.x >= 0)
      && (loc.y >= 0)
      && (loc.x < bmap.width)
      && (loc.y < bmap.height)
   )

add_marker_to_tiles : (
      Type ->
      (Battlemap.Location.Ref, Battlemap.Navigator.RangeIndicator.Type) ->
      (Array.Array Battlemap.Tile.Type) ->
      (Array.Array Battlemap.Tile.Type)
   )
add_marker_to_tiles bmap (location, indicator) tiles =
   (Util.Array.update_unsafe
      (location_to_index bmap (Battlemap.Location.from_ref location))
      (
         (Battlemap.Tile.set_marker
            (Just
               (Battlemap.Navigator.RangeIndicator.get_marker indicator)
            )
         )
      )
      tiles
   )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
reset : Type -> Type
reset bmap =
   {bmap |
      content = (Array.map (Battlemap.Tile.reset) bmap.content),
      navigator = Nothing
   }

get_navigator_location : Type -> (Maybe Battlemap.Location.Type)
get_navigator_location bmap =
   case bmap.navigator of
      (Just navigator) ->
         (Just
            (Battlemap.Navigator.get_current_location navigator)
         )

      Nothing -> Nothing

get_navigator_remaining_points : Type -> Int
get_navigator_remaining_points bmap =
   case bmap.navigator of
      (Just navigator) -> (Battlemap.Navigator.get_remaining_points navigator)
      Nothing -> -1

set_navigator : (
      Battlemap.Location.Type ->
      Int ->
      Int ->
      (Battlemap.Location.Type -> Bool) ->
      Type ->
      Type
   )
set_navigator start_loc movement_points attack_range can_cross bmap =
   let
      new_navigator =
         (Battlemap.Navigator.new
            start_loc
            movement_points
            attack_range
            (\loc -> ((can_cross loc) && (has_location bmap loc)))
         )
      new_range_markers = (Battlemap.Navigator.get_range_markers new_navigator)
   in
      {bmap |
         content =
            (List.foldr
               (add_marker_to_tiles bmap)
               bmap.content
               new_range_markers
            ),
         navigator = (Just new_navigator)
      }

add_step_to_navigator : (
      Type ->
      Battlemap.Direction.Type ->
      (Battlemap.Location.Type -> Bool) ->
      (Maybe Type)
add_step_to_navigator bmap dir can_cross =
   case bmap.navigator of
      (Just navigator) ->
         let
            new_navigator =
               (Battlemap.Navigator.add_step
                  navigator
                  (\loc -> ((can_cross loc) && (has_location bmap loc)))
                  dir
               )
         in
          case new_navigator of
            (Just _) -> {bmap | navigator = new_navigator}
            Nothing -> Nothing

      _ -> Nothing
--------------------------------------------------------------------------------

apply_to_all_tiles : (
      Type -> (Battlemap.Tile.Type -> Battlemap.Tile.Type) -> Type
   )
apply_to_all_tiles bmap fun =
   {bmap |
      content = (Array.map fun bmap.content)
   }

apply_to_tile : (
      Type ->
      Battlemap.Location.Type ->
      (Battlemap.Tile.Type -> Battlemap.Tile.Type) ->
      (Maybe Type)
   )
apply_to_tile bmap loc fun =
   let
      index = (location_to_index bmap loc)
      at_index = (Array.get index bmap.content)
   in
      case at_index of
         Nothing ->
            Nothing
         (Just tile) ->
            (Just
               {bmap |
                  content =
                     (Array.set
                        index
                        (fun tile)
                        bmap.content
                     )
               }
            )

apply_to_tile_unsafe : (
      Type ->
      Battlemap.Location.Type ->
      (Battlemap.Tile.Type -> Battlemap.Tile.Type) ->
      Type
   )
apply_to_tile_unsafe bmap loc fun =
   let
      index = (location_to_index bmap loc)
      at_index = (Array.get index bmap.content)
   in
      case at_index of
         Nothing -> bmap
         (Just tile) ->
            {bmap |
               content =
                  (Array.set
                     index
                     (fun tile)
                     bmap.content
                  )
            }
