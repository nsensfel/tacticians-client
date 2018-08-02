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
      Struct.Location.Type ->
      Int ->
      Int ->
      Int ->
      Struct.Map.Type ->
      Struct.Map.Type
   )
set_tile_to loc main_class border_class variant_ix map =
   (Struct.Map.set_tile_to
      loc
      (Struct.Tile.new_instance
         0
         0
         main_class
         border_class
         variant_ix
         -1
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
                  let
                     (main, border, variant) =
                        (Struct.TilePattern.get_target pattern)
                  in
                     (set_tile_to
                        loc
                        main
                        border
                        variant
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
                        let
                           (main, border, variant) =
                              (Struct.TilePattern.get_target pattern)
                        in
                           (set_tile_to
                              loc
                              main
                              border
                              variant
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
