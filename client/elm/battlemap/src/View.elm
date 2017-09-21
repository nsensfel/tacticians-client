module View exposing (view)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

import Update exposing (Msg(..))
import Model exposing (Model)

import Battlemap.Html as Batmap exposing (view)
import Battlemap.Direction exposing (Direction(..))

import Dict as Dt exposing (get)
-- VIEW

view : Model -> (Html Msg)
view model =
   (div
      []
      [
         (button
            [ (onClick (DirectionRequest Left)) ]
            [ (text "Left") ]
         ),
         (button
            [ (onClick (DirectionRequest Down)) ]
            [ (text "Down") ]
         ),
         (button
            [ (onClick (DirectionRequest Up)) ]
            [ (text "Up") ]
         ),
         (button
            [ (onClick (DirectionRequest Right)) ]
            [ (text "Right") ]
         ),
         (button
            [ (onClick EndTurn) ]
            [ (text "Apply") ]
         ),
         (div
            []
            [(Batmap.view model)]
         ),
         (div
            []
            [
               (text
                  (case (model.selection, model.navigator) of
                     (Nothing, _) -> ""
                     (_, Nothing) -> ""
                     ((Just char_id), (Just nav)) ->
                        case (Dt.get char_id model.characters) of
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
