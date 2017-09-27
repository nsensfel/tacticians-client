module Update.DirectionRequest exposing (apply_to)

import Dict

import Battlemap.Direction
import Battlemap.Navigator.Move

import Model
import Error

make_it_so : Model.Type -> Battlemap.Direction.Type -> Model.Type
make_it_so model dir =
   case model.selection of
      Nothing ->
         (Model.invalidate
            model
            (Error.new
               Error.Programming
               "DirectionRequest: model moving char, no selection."
            )
         )
      (Just selection) ->
         let
            (new_bmap, new_nav) =
               (Battlemap.Navigator.Move.to
                  model.battlemap
                  selection.navigator
                  dir
                  (Dict.values model.characters)
               )
         in
            {model |
               state = Model.MovingCharacterWithButtons,
               battlemap = new_bmap,
               selection = (Just {selection | navigator = new_nav})
            }


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
