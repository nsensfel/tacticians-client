module View exposing (view)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import UI

import View.Battlemap
import View.Header
import View.Footer

import Event
import Model

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
view : Model.Type -> (Html.Html Event.Type)
view model =
   (Html.div
      [
         (Html.Attributes.class "battlemap")
      ]
      [
         (View.Header.get_html model),
         (Html.div
            [
               (Html.Attributes.class "battlemap-container")
            ]
            [
               (View.Battlemap.get_html
                  model.battlemap
                  (UI.get_zoom_level model.ui)
                  (Dict.values model.characters)
               )
            ]
         ),
         (View.Footer.get_html model)
      ]
   )
