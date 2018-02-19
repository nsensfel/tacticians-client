module ElmModule.View exposing (view)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
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
                     (View.Battlemap.get_html model)
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
