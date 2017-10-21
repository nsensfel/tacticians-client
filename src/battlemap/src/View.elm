module View exposing (view)

import Dict
import Html
import Html.Attributes

import View.Battlemap

import View.Controls
import View.Status

import Event
import Model

view : Model.Type -> (Html.Html Event.Type)
view model =
   (Html.div
      [
         (Html.Attributes.class "battlemap")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "battlemap-controls")
            ]
            (View.Controls.view)
         ),
         (Html.div
            [
               (Html.Attributes.class "battlemap-container")
            ]
            [
               (View.Battlemap.get_html
                  model.battlemap
                  model.ui_scale
                  (Dict.values model.characters)
               )
            ]
         ),
         (View.Status.view model)
      ]
   )
