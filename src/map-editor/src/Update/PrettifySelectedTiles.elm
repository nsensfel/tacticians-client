module Update.PrettifySelectedTiles exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

import Set

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Location
import Struct.Map
import Struct.Model
import Struct.Tile
import Struct.TileInstance
import Struct.TilePattern
import Struct.Toolbox

import Util.List

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
neighborhood_tile_instances : (
      Struct.Location.Type ->
      Struct.Map.Type ->
      (List Struct.TileInstance.Type)
   )
neighborhood_tile_instances loc map =
   (List.map
      (\e ->
         case (Struct.Map.try_getting_tile_at e map) of
            Nothing -> (Struct.TileInstance.error -1 -1)
            (Just t) -> t
      )
      (Struct.Location.get_full_neighborhood loc)
   )

get_nigh_patterns : (
      Struct.Tile.FamilyID ->
      (List Struct.TileInstance.Type) ->
      (List (Struct.Tile.FamilyID, Struct.Tile.Ref))
   )
get_nigh_patterns source_fm full_neighborhood =
   (Set.toList
      (List.foldl
         (\e -> \acc ->
            let
               e_fm = (Struct.TileInstance.get_family e)
            in
               if (e_fm <= source_fm)
               then acc
               else
                  (Set.insert
                     (
                        (Struct.TileInstance.get_family e),
                        (Struct.TileInstance.get_class_id e)
                     )
                     acc
                  )
         )
         (Set.empty)
         full_neighborhood
      )
   )

nigh_pattern_to_border : (
      Struct.Model.Type ->
      (List Struct.TileInstance.Type) ->
      (Struct.Tile.FamilyID, Struct.Tile.Ref) ->
      (Struct.TileInstance.Border)
   )
nigh_pattern_to_border model full_neighborhood nigh_pattern =
   let
      (fm, tid) = nigh_pattern
      pattern = (Struct.TilePattern.get_pattern_for fm full_neighborhood)
   in
      case (Dict.get pattern model.tile_patterns) of
         Nothing ->
            case
               (Util.List.get_first
                  (\e ->
                     (Struct.TilePattern.patterns_match
                        pattern
                        (Struct.TilePattern.get_pattern e)
                     )
                  )
                  model.wild_tile_patterns
               )
            of
               Nothing -> (Struct.TileInstance.new_border "0" "0")
               (Just tp) ->
                  (Struct.TileInstance.new_border
                     tid
                     (Struct.TilePattern.get_variant_id tp)
                  )

         (Just v) -> (Struct.TileInstance.new_border tid v)

apply_to_location : (
      Struct.Model.Type ->
      Struct.Location.Type ->
      Struct.Map.Type ->
      Struct.Map.Type
   )
apply_to_location model loc map =
   case (Struct.Map.try_getting_tile_at loc map) of
      Nothing -> map
      (Just base) ->
         let
            full_neighborhood = (neighborhood_tile_instances loc map)
         in
            (Struct.Map.set_tile_to
               loc
               (Struct.TileInstance.set_borders
                  (List.map
                     (nigh_pattern_to_border model full_neighborhood)
                     (get_nigh_patterns
                        (Struct.TileInstance.get_family base)
                        full_neighborhood
                     )
                  )
                  base
               )
               map
            )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   (
      {model |
         map =
            (List.foldl
               (apply_to_location model)
               model.map
               (Struct.Toolbox.get_selection model.toolbox)
            )
      },
      Cmd.none
   )
