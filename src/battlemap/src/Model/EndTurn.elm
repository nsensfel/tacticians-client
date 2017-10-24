module Model.EndTurn exposing (apply_to)

import Dict

import Battlemap

import Character

import Error

import Model

make_it_so : Model.Type -> Character.Ref -> Model.Type
make_it_so model char_ref =
   case (Battlemap.try_getting_navigator_location model.battlemap) of
      (Just location) ->
         (Model.reset
            model
            (Dict.update
               char_ref
               (\maybe_char ->
                  case maybe_char of
                     (Just char) ->
                        (Just
                           (Character.set_location location char)
                        )
                     Nothing -> Nothing
               )
               model.characters
            )
         )

      Nothing ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               "EndTurn: model moving char, no navigator location."
            )
         )

apply_to : Model.Type -> Model.Type
apply_to model =
   case (Model.get_state model) of
      (Model.MovingCharacterWithButtons char_ref) -> (make_it_so model char_ref)
      (Model.MovingCharacterWithClick char_ref) -> (make_it_so model char_ref)
      _ ->
         (Model.invalidate
            model
            (Error.new
               Error.IllegalAction
               "This can only be done while moving a character."
            )
         )
