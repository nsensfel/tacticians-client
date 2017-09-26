module View.Status exposing (view)

import Dict

import Html

import Error
import Event
import Model

moving_character_text : Model.Type -> String
moving_character_text model =
   case model.selection of
      Nothing -> "Error: no model.selection."
      (Just selection) ->
         case (Dict.get selection.character model.characters) of
            Nothing -> "Error: Unknown character selected."
            (Just char) ->
               (
                  "Controlling "
                  ++ char.name
                  ++ ": "
                  ++ (toString selection.navigator.remaining_points)
                  ++ "/"
                  ++ (toString char.movement_points)
                  ++ " movement points remaining."
               )

view : Model.Type -> (Html.Html Event.Type)
view model =
   (Html.text
      (case model.state of
         Model.Default -> "Click on a character to control it."
         Model.MovingCharacterWithButtons -> (moving_character_text model)
         Model.MovingCharacterWithClick -> (moving_character_text model)
         Model.FocusingTile -> "Error: Unimplemented."
         (Model.Error Error.Programming) ->
            "Error of programming, please report."
         (Model.Error Error.IllegalAction) ->
            "This cannot be done while in this state."
      )
   )
