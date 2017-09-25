module View.Status exposing (view)

import Dict

import Html

import Update
import Model

view : Model.Type -> (Html.Html Update.Type)
view model =
   (Html.text
      (case (model.state, model.navigator) of
         (_, Nothing) -> ""
         ((Model.MovingCharacter char_id), (Just nav)) ->
            case (Dict.get char_id model.characters) of
               Nothing -> ""
               (Just char) ->
                  (
                     "Controlling "
                     ++ char.name
                     ++ ": "
                     ++ (toString nav.remaining_points)
                     ++ "/"
                     ++ (toString char.movement_points)
                     ++ " movement points remaining."
                  )
         (_, _) -> ""
      )
   )
