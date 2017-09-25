module Update.DirectionRequest exposing (apply_to)

import Dict

import Battlemap.Direction
import Battlemap.Navigator.Move

import Model

apply_to : Model.Type -> Battlemap.Direction.Type -> Model.Type
apply_to model dir =
   case (model.state, model.navigator) of
      (_ , Nothing) -> model
      ((Model.MovingCharacter _), (Just nav)) ->
         let
            (new_bmap, new_nav) =
               (Battlemap.Navigator.Move.to
                  model.battlemap
                  nav
                  dir
                  (Dict.values model.characters)
               )
         in
            {model |
               battlemap = new_bmap,
               navigator = (Just new_nav)
            }
      (_, _) -> model
