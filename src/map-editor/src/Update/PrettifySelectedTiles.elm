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
      (Dict.Dict Int Struct.Tile.Type) ->
      Struct.Location.Type ->
      Int ->
      Int ->
      Int ->
      Struct.Map.Type ->
      Struct.Map.Type
   )
set_tile_to tiles loc main_class border_class variant_ix map =
   let
      true_variant_ix =
         if (variant_ix >= 0)
         then variant_ix
         else
            case (Struct.Map.try_getting_tile_at loc map) of
               Nothing -> 0
               (Just t) -> (Struct.Tile.get_variant_ix t)
   in
      (Struct.Map.set_tile_to
         loc
         (case (Dict.get main_class tiles) of
            Nothing ->
               (Struct.Tile.new_instance
                  loc.x
                  loc.y
                  main_class
                  border_class
                  true_variant_ix
                  -1
                  -1
               )

            (Just t) ->
               (Struct.Tile.new_instance
                  loc.x
                  loc.y
                  main_class
                  border_class
                  true_variant_ix
                  (Struct.Tile.get_cost t)
                  (Struct.Tile.get_family t)
               )
         )
         map
      )

find_matching_pattern : (
      Struct.Tile.Instance ->
      (List Struct.Tile.Instance) ->
      (List Struct.TilePattern.Type) ->
      (Maybe (Int, Int, Int))
   )
find_matching_pattern source full_neighborhood candidates =
   case (Util.List.pop candidates) of
      (Just (c, rc)) ->
         case (Struct.TilePattern.matches full_neighborhood source c) of
            (True, main, border, variant) -> (Just (main, border, variant))
            (False, _, _, _) ->
               (find_matching_pattern source full_neighborhood rc)

      Nothing -> Nothing

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
            oob_tile = (Struct.Tile.new_instance -1 -1 -1 -1 -1 -1 -1)
            full_neighborhood =
               (List.map
                  (\e ->
                     case (Struct.Map.try_getting_tile_at e map) of
                        Nothing -> oob_tile
                        (Just t) -> t
                  )
                  (Struct.Location.get_full_neighborhood loc)
               )
         in
            case
               (find_matching_pattern
                  base
                  full_neighborhood
                  model.tile_patterns
               )
            of
               (Just (main, border, variant)) ->
                  (set_tile_to model.tiles loc main border variant map)

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
               (apply_to_location model)
               model.map
               (Struct.Toolbox.get_selection model.toolbox)
            )
      },
      Cmd.none
   )
