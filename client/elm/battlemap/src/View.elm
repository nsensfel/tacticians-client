module View exposing (view)

import Dict

import Html
import Html.Events

import Battlemap.Direction
import Battlemap.Html

import Update
import Model

view : Model.Type -> (Html.Html Update.Type)
view model =
   (Html.div
      []
      [
         (Html.button
            [
               (Html.Events.onClick
                  (Update.DirectionRequest Battlemap.Direction.Left)
               )
            ]
            [ (Html.text "Left") ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Update.DirectionRequest Battlemap.Direction.Down)
               )
            ]
            [ (Html.text "Down") ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Update.DirectionRequest Battlemap.Direction.Up)
               )
            ]
            [ (Html.text "Up") ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Update.DirectionRequest Battlemap.Direction.Right)
               )
            ]
            [ (Html.text "Right") ]
         ),
         (Html.button
            [ (Html.Events.onClick Update.EndTurn) ]
            [ (Html.text "Apply") ]
         ),
         (Html.div
            []
            [(Battlemap.Html.view model.battlemap)]
         ),
         (Html.div
            []
            [
               (Html.text
                  (case (model.selection, model.navigator) of
                     (Nothing, _) -> ""
                     (_, Nothing) -> ""
                     ((Just char_id), (Just nav)) ->
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
                  )
               )
            ]
         )
      ]
   )
