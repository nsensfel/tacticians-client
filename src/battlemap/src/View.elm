module View exposing (view)

import Dict
import Html

import View.Battlemap

import View.Controls
import View.Status

import Event
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
         (View.Battlemap.get_html
            model.battlemap
            32
            (Dict.values model.characters)
         ),
         (Html.div
            []
            [ (View.Status.view model) ]
         )
      ]
   )
