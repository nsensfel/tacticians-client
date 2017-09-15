module View exposing (view)

import Html exposing (Html, button, div, text, table, tr, td)
import Html.Events exposing (onClick)

import Update exposing (Msg(Increment, Decrement))
import Model exposing (Model)

import Battlemap.Html as Batmap exposing (view)

-- VIEW

view : Model -> (Html Msg)
view model =
   (div
      []
      [
         (button
            [ (onClick Decrement) ]
            [ (text "-") ]
         ),
         (div
            []
            [ (text (toString model)) ]
         ),
         (button
            [ (onClick Increment) ]
            [ (text "+") ]
         ),
         (div
            []
            [(Batmap.view model)]
         )
      ]
   )
