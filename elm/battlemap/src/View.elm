module View exposing (view)

import Html

import Battlemap.Html

import View.Controls
import View.Status

import Event
import Update
import Model

view : Model.Type -> (Html.Html Event.Type)
view model =
   (Html.div
      []
      [
         (Html.div
            []
            (View.Controls.view)
         ),
         (Html.div
            []
            [ (Battlemap.Html.view model.battlemap) ]
         ),
         (Html.div
            []
            [ (View.Status.view model) ]
         )
      ]
   )
