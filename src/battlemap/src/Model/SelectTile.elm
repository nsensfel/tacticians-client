module Model.SelectTile exposing (apply_to)

import Battlemap
import Battlemap.Direction
import Battlemap.Location

import Model.RequestDirection
import Model.EndTurn

import Model
import Error

autopilot : Battlemap.Direction.Type -> Model.Type -> Model.Type
autopilot dir model =
   (Model.RequestDirection.apply_to model dir)

go_to_tile : Model.Type -> Battlemap.Location.Ref -> Model.Type
go_to_tile model loc_ref =
   case (Battlemap.try_getting_navigator_location model.battlemap) of
      (Just nav_loc) ->
         if (loc_ref == (Battlemap.Location.get_ref nav_loc))
         then
            -- We are already there.
            if (model.state == Model.MovingCharacterWithClick)
            then
               -- And we just clicked on that tile.
               (Model.EndTurn.apply_to model)
            else
               -- And we didn't just click on that tile.
               {model | state = Model.MovingCharacterWithClick}
         else
            -- We have to try getting there.
            case
               (Battlemap.try_getting_navigator_path_to
                  model.battlemap
                  loc_ref
               )
            of
               (Just path) ->
                  let
                     new_model = (List.foldr (autopilot) model path)
                  in
                     {new_model | state = Model.MovingCharacterWithClick}

               Nothing -> -- Clicked outside of the range indicator
                  (Model.reset model model.characters)
      Nothing -> -- Clicked outside of the range indicator
         (Model.reset model model.characters)

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
