module Update.PrettifySelectedTiles exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Location
import Struct.Map
import Struct.Model
import Struct.Tile
import Struct.TilePattern
import Struct.Toolbox

import Util.List

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
set_tile_to : (
      Struct.Model.Type ->
      Struct.Location.Type ->
      Int ->
      Struct.Map.Type ->
      Struct.Map.Type
   )
set_tile_to model loc id map =
   (Struct.Map.set_tile_to
      loc
      (Struct.Tile.solve_tile_instance
         (Dict.values model.tiles)
         (Struct.Tile.error_tile_instance id loc.x loc.y)
      )
      map
   )

apply_to_location : (
      (List Struct.TilePattern.Type) ->
      Struct.Model.Type ->
      Struct.Location.Type ->
      Struct.Map.Type ->
      Struct.Map.Type
   )
apply_to_location wild_patterns model loc map =
   case (Struct.Map.try_getting_tile_at loc map) of
      Nothing -> map
      (Just base) ->
         let
            base_id = (Struct.Tile.get_type_id base)
            full_neighborhood_class_ids =
               (List.map
                  (\e ->
                     case (Struct.Map.try_getting_tile_at e map) of
                        Nothing -> -1
                        (Just t) -> (Struct.Tile.get_type_id t)
                  )
                  (Struct.Location.get_full_neighborhood loc)
               )
         in
            case
               (Util.List.get_first
                  (Struct.TilePattern.matches
                     full_neighborhood_class_ids
                     base_id
                  )
                  (Struct.Model.get_tile_patterns_for base_id model)
               )
            of
               (Just pattern) -> -- TODO
                  (set_tile_to
                     model
                     loc
                     (Struct.TilePattern.get_target pattern)
                     map
                  )

               Nothing ->
                  case
                     (Util.List.get_first
                        (Struct.TilePattern.matches
                           full_neighborhood_class_ids
                           base_id
                        )
                        wild_patterns
                     )
                  of
                     (Just pattern) -> -- TODO
                        (set_tile_to
                           model
                           loc
                           (Struct.TilePattern.get_target pattern)
                           map
                        )

                     Nothing -> map

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
               (apply_to_location
                  (Struct.Model.get_wild_tile_patterns model)
                  model
               )
               model.map
               (Struct.Toolbox.get_selection model.toolbox)
            )
      },
      Cmd.none
   )
