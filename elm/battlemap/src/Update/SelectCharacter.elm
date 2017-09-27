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
import Event
import Error

display_range : (
      Int ->
      Battlemap.Location.Ref ->
      Battlemap.RangeIndicator.Type ->
      Battlemap.Type ->
      Battlemap.Type
   )
display_range dist loc_ref indicator bmap =
   (Battlemap.apply_to_tile_unsafe
      bmap
      (Battlemap.Location.from_ref loc_ref)
      (\e ->
         {e |
            mod_level =
               (
                  if (indicator.distance <= dist)
                  then
                     (Just Battlemap.Tile.CanBeReached)
                  else
                     (Just Battlemap.Tile.CanBeAttacked)
               )
         }
      )
   )


make_it_so : Model.Type -> Character.Ref -> Model.Type
make_it_so model char_id =
   case (Dict.get char_id model.characters) of
      Nothing -> {model | state = (Model.Error Error.Programming)}
      (Just char) ->
         let
            new_range_indicator =
               (Battlemap.RangeIndicator.generate
                  model.battlemap
                  char.location
                  char.movement_points
                  (char.movement_points + char.atk_dist)
               )
         in
            {model |
               state = Model.MovingCharacterWithClick,
               battlemap =
                  (
                     (Dict.foldl
                        (display_range char.movement_points)
                        (Battlemap.apply_to_all_tiles
                           model.battlemap
                           (Battlemap.Tile.reset)
                        )
                        new_range_indicator
                     )
                  ),
               selection =
                  (Just
                     {
                        character = char_id,
                        navigator =
                           (Battlemap.Navigator.new
                              char.location
                              char.movement_points
                           ),
                        range_indicator = new_range_indicator
                     }
                  )
            }

apply_to : Model.Type -> Character.Ref -> Model.Type
apply_to model char_id =
   case model.state of
      _ -> (make_it_so model char_id)
