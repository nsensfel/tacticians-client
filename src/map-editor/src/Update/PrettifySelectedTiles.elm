module Update.PrettifySelectedTiles exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

import Set

-- Shared ----------------------------------------------------------------------
import Shared.Util.List

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Map
import BattleMap.Struct.Tile
import BattleMap.Struct.TileInstance

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.TilePattern
import Struct.Toolbox

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
neighborhood_tile_instances : (
      BattleMap.Struct.Location.Type ->
      BattleMap.Struct.Map.Type ->
      (List BattleMap.Struct.TileInstance.Type)
   )
neighborhood_tile_instances loc map =
   (List.map
      (\e ->
         case (BattleMap.Struct.Map.maybe_get_tile_at e map) of
            Nothing -> (BattleMap.Struct.TileInstance.error -1 -1)
            (Just t) -> t
      )
      (BattleMap.Struct.Location.get_full_neighborhood loc)
   )

get_nigh_patterns : (
      BattleMap.Struct.Tile.FamilyID ->
      (List BattleMap.Struct.TileInstance.Type) ->
      (List (BattleMap.Struct.Tile.FamilyID, BattleMap.Struct.Tile.Ref))
   )
get_nigh_patterns source_fm full_neighborhood =
   (Set.toList
      (List.foldl
         (\e -> \acc ->
            let
               e_fm = (BattleMap.Struct.TileInstance.get_family e)
            in
               if (e_fm <= source_fm)
               then acc
               else
                  (Set.insert
                     (
                        (BattleMap.Struct.TileInstance.get_family e),
                        (BattleMap.Struct.TileInstance.get_class_id e)
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
      (List BattleMap.Struct.TileInstance.Type) ->
      (BattleMap.Struct.Tile.FamilyID, BattleMap.Struct.Tile.Ref) ->
      (BattleMap.Struct.TileInstance.Border)
   )
nigh_pattern_to_border model full_neighborhood nigh_pattern =
   let
      (fm, tid) = nigh_pattern
      pattern = (Struct.TilePattern.get_pattern_for fm full_neighborhood)
   in
      case (Dict.get pattern model.tile_patterns) of
         Nothing ->
            case
               (Shared.Util.List.get_first
                  (\e ->
                     (Struct.TilePattern.patterns_match
                        pattern
                        (Struct.TilePattern.get_pattern e)
                     )
                  )
                  model.wild_tile_patterns
               )
            of
               Nothing -> (BattleMap.Struct.TileInstance.new_border "0" "0")
               (Just tp) ->
                  (BattleMap.Struct.TileInstance.new_border
                     tid
                     (Struct.TilePattern.get_variant_id tp)
                  )

         (Just v) -> (BattleMap.Struct.TileInstance.new_border tid v)

apply_to_location : (
      Struct.Model.Type ->
      BattleMap.Struct.Location.Type ->
      BattleMap.Struct.Map.Type ->
      BattleMap.Struct.Map.Type
   )
apply_to_location model loc map =
   case (BattleMap.Struct.Map.maybe_get_tile_at loc map) of
      Nothing -> map
      (Just base) ->
         let
            full_neighborhood = (neighborhood_tile_instances loc map)
         in
            (BattleMap.Struct.Map.set_tile_to
               loc
               (BattleMap.Struct.TileInstance.set_borders
                  (List.map
                     (nigh_pattern_to_border model full_neighborhood)
                     (get_nigh_patterns
                        (BattleMap.Struct.TileInstance.get_family base)
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
