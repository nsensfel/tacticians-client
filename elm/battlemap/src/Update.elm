module Update exposing (update)

import Event

import Model
import Model.RequestDirection
import Model.SelectTile
import Model.SelectCharacter
import Model.EndTurn

update : Event.Type -> Model.Type -> Model.Type
update event model =
   let
      new_model = (Model.clear_error model)
   in
   case event of
      (Event.DirectionRequested d) ->
         (Model.DirectionRequest.apply_to new_model d)

      (Event.TileSelected loc) ->
         (Model.SelectTile.apply_to new_model loc)

      (Event.CharacterSelected char_id) ->
         (Model.SelectCharacter.apply_to new_model char_id)

      Event.TurnEnded ->
         (Model.EndTurn.apply_to new_model)
