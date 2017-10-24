module View.Footer.TabMenu.Settings exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Event

import Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
scale_button : Float -> String -> (Html.Html Event.Type)
scale_button mod label =
   (Html.button
      [
         (Html.Events.onClick
            (Event.ScaleChangeRequested mod)
         )
      ]
      [ (Html.text label) ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer-tabmenu-content"),
         (Html.Attributes.class "battlemap-footer-tabmenu-content-settings")
      ]
      [
         (scale_button (0.75) "Zoom -"),
         (scale_button 0 "Zoom Reset"),
         (scale_button (1.15) "Zoom +"),
         (Html.button
            [
               (Html.Events.onClick Event.DebugTeamSwitchRequest)
            ]
            [ (Html.text "[DEBUG] Switch team") ]
         )
      ]
   )
