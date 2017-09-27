module Update.SelectTile exposing (apply_to)

import Dict

import Character

import Battlemap
import Battlemap.Direction
import Battlemap.Location
import Battlemap.Navigator
import Battlemap.Tile
import Battlemap.RangeIndicator

import Update.DirectionRequest
import Update.EndTurn

import Model
import Error

autopilot : Battlemap.Direction.Type -> Model.Type -> Model.Type
autopilot dir model =
   (Update.DirectionRequest.apply_to model dir)

go_to_tile : Model.Type -> Battlemap.Location.Ref -> Model.Type
go_to_tile model loc_ref =
   case model.selection of
      Nothing ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               "SelectTile: model moving char, no selection."
            )
         )
      (Just selection) ->
         case (Dict.get loc_ref selection.range_indicator) of
            Nothing -> -- Clicked outside of the range indicator
               (Model.reset model)
            (Just indicator) ->
               let
                  new_model =
                     (List.foldr
                        (autopilot)
                        {model |
                           battlemap =
                              (Battlemap.apply_to_all_tiles
                                 model.battlemap
                                 (Battlemap.Tile.set_direction
                                    Battlemap.Direction.None
                                 )
                              ),
                           selection =
                              (Just
                                 {
                                    selection |
                                    navigator =
                                       (Battlemap.Navigator.reset
                                          selection.navigator
                                       )
                                 }
                              )
                        }
                        indicator.path
                     )
               in
                  if
                  (
                     (model.state == Model.MovingCharacterWithClick)
                     &&
                     (
                        (Battlemap.Location.get_ref
                           selection.navigator.current_location
                        )
                        == loc_ref
                     )
                  )
                  then
                     (Update.EndTurn.apply_to new_model)
                  else
                     {new_model | state = Model.MovingCharacterWithClick}


apply_to : Model.Type -> Battlemap.Location.Ref -> Model.Type
apply_to model loc_ref =
   case (Model.get_state model) of
      Model.MovingCharacterWithButtons -> (go_to_tile model loc_ref)
      Model.MovingCharacterWithClick -> (go_to_tile model loc_ref)
      _ ->
         (Model.invalidate
            model
            (Error.new
               Error.IllegalAction
               "This can only be done while moving a character."
            )
         )
