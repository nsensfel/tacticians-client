module Update exposing (update)

import Event

import Model
import Model.RequestDirection
import Model.SelectTile
import Model.SelectCharacter
import Model.EndTurn

update : Event.Type -> Model.Type -> (Model.Type, (Cmd Event.Type))
update event model =
   let
      new_model = (Model.clear_error model)
   in
   case event of
      (Event.DirectionRequested d) ->
         ((Model.RequestDirection.apply_to new_model d), Cmd.none)

      (Event.TileSelected loc) ->
         ((Model.SelectTile.apply_to new_model loc), Cmd.none)

      (Event.CharacterSelected char_id) ->
         ((Model.SelectCharacter.apply_to new_model char_id), Cmd.none)

      Event.TurnEnded ->
         ((Model.EndTurn.apply_to new_model), Cmd.none)
