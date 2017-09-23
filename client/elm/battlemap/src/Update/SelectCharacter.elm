module Update.SelectCharacter exposing (apply_to)

import Dict

import Character

import Battlemap
import Battlemap.Direction
import Battlemap.Location
import Battlemap.Navigator
import Battlemap.Tile
import Battlemap.RangeIndicator

import Model

display_range : (
      Battlemap.Location.Ref ->
      Battlemap.RangeIndicator.Type ->
      Battlemap.Type ->
      Battlemap.Type
   )
display_range loc_ref indicator bmap =
   (Battlemap.apply_to_tile_unsafe
      bmap
      (Battlemap.Location.from_ref loc_ref)
      (\e -> {e | mod_level = (Just Battlemap.Tile.CanBeReached)})
   )


apply_to : Model.Type -> Character.Ref -> Model.Type
apply_to model char_id =
   case (Dict.get char_id model.characters) of
      Nothing -> model
      (Just char) ->
         let
            new_range_indicator =
               (Battlemap.RangeIndicator.generate
                  model.battlemap
                  char.location
                  char.movement_points
               )
         in
            {model |
               selection = (Just char_id),
               battlemap =
                  (Battlemap.apply_to_all_tiles
                     (Dict.foldl
                        (display_range)
                        model.battlemap
                        new_range_indicator
                     )
                     (Battlemap.Tile.set_navigation Battlemap.Direction.None)
                  ),
               navigator =
                  (Just
                     (Battlemap.Navigator.new_navigator
                        char.location
                        char.movement_points
                     )
                  ),
               range_indicator = new_range_indicator
            }
