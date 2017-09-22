module Update exposing (update, Type(..))

import Model

import Update.DirectionRequest
import Update.SelectCharacter
import Update.EndTurn

import Battlemap
import Battlemap.Direction
import Battlemap.Navigator

import Dict

import Character

type Type =
   DirectionRequest Battlemap.Direction.Type
   | SelectCharacter Character.Ref
   | EndTurn

update : Type -> Model.Type -> Model.Type
update msg model =
   case msg of
      (DirectionRequest d) ->
         (Update.DirectionRequest.apply_to model d)

      (SelectCharacter char_id) ->
         (Update.SelectCharacter.apply_to model char_id)

      EndTurn ->
         (Update.EndTurn.apply_to model)
