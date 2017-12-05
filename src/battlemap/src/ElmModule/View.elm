module ElmModule.View exposing (view)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.UI
import Struct.Event
import Struct.Model

import View.Battlemap
import View.SideBar
import View.Footer

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
view : Struct.Model.Type -> (Html.Html Struct.Event.Type)
view model =
   (Html.div
      [
         (Html.Attributes.class "fullscreen-module")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "battlemap-left-panel")
            ]
            [
               (Html.div
                  [
                     (Html.Attributes.class "battlemap-container")
                  ]
                  [
                     (View.Battlemap.get_html
                        model.battlemap
                        (Struct.UI.get_zoom_level model.ui)
                        (Dict.values model.characters)
                     )
                  ]
               ),
               (View.Footer.get_html model)
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "battlemap-right-panel")
            ]
            [
               (View.SideBar.get_html model)
            ]
         )
      ]
   )
