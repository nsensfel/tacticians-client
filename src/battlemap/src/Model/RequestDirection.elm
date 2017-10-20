module Model.RequestDirection exposing (apply_to)

import Dict

import Battlemap
import Battlemap.Direction
import Battlemap.Location


import Character

import Model
import Error

make_it_so : Model.Type -> Battlemap.Direction.Type -> Model.Type
make_it_so model dir =
   case model.selection of
      (Model.SelectedCharacter char_id) ->
         let
            new_bmap =
               (Battlemap.try_adding_step_to_navigator
                  model.battlemap
                  (Dict.values model.characters)
                  dir
               )
         in
            case new_bmap of
               (Just bmap) ->
                  {model |
                     state = Model.MovingCharacterWithButtons,
                     battlemap = bmap
                  }

               Nothing ->
                  (Model.invalidate
                     model
                     (Error.new
                        Error.IllegalAction
                        "Unreachable/occupied tile."
                     )
                  )

      _ ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               "DirectionRequest: model moving char, no char selected."
            )
         )

apply_to : Model.Type -> Battlemap.Direction.Type -> Model.Type
apply_to model dir =
   case (Model.get_state model) of
      Model.MovingCharacterWithButtons -> (make_it_so model dir)
      Model.MovingCharacterWithClick -> (make_it_so model dir)
      _ ->
         (Model.invalidate
            model
            (Error.new
               Error.IllegalAction
               "This can only be done while moving a character."
            )
         )
