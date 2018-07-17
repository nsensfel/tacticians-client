module Update.PrettifySelectedTiles exposing (apply_to)
-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Toolbox
import Struct.Map
import Struct.Tile
import Struct.TilePattern
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to_location : (
      (List Struct.TilePattern.Type) ->
      Struct.Model.Type ->
      Struct.Location.Type ->
      Struct.Map.Type ->
      Struct.Map.Type ->
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
                     case (Struct.Map.try_getting_tile_at \e map) of
                        Nothing -> -1
                        (Just e) -> (Struct.Tile.get_type_id e)
                  )
                  (Struct.Map.try_getting_tile_at loc map)
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
      }
      {model | toolbox = (Struct.Toolbox.set_mode mode model.toolbox)},
      Cmd.none
   )
