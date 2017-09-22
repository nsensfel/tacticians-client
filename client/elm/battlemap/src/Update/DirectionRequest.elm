module Update.DirectionRequest exposing (apply_to)

import Dict

import Battlemap.Direction
import Battlemap.Navigator

import Model

apply_to : Model.Type -> Battlemap.Direction.Type -> Model.Type
apply_to model dir =
   case (model.selection, model.navigator) of
      (Nothing, _) -> model
      (_ , Nothing) -> model
      ((Just char_id), (Just nav)) ->
         let
            (new_bmap, new_nav) =
               (Battlemap.Navigator.go
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
