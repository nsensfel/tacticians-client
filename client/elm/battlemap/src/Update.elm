module Update exposing (update)

import Event

import Model

import Update.DirectionRequest
import Update.SelectTile
import Update.SelectCharacter
import Update.EndTurn

update : Event.Type -> Model.Type -> Model.Type
update event model =
   case event of
      (Event.DirectionRequest d) ->
         (Update.DirectionRequest.apply_to model d)

      (Event.SelectTile loc) ->
         (Update.SelectTile.apply_to model loc)

      (Event.SelectCharacter char_id) ->
         (Update.SelectCharacter.apply_to model char_id)

      Event.EndTurn ->
         (Update.EndTurn.apply_to model)
