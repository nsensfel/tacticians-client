module View.SubMenu.Settings exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
scale_button : Float -> String -> (Html.Html Struct.Event.Type)
scale_button mod label =
   (Html.button
      [
         (Html.Events.onClick
            (Struct.Event.ScaleChangeRequested mod)
         )
      ]
      [ (Html.text label) ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "tabmenu-content"),
         (Html.Attributes.class "tabmenu-settings-tab")
      ]
      [
         (scale_button (0.75) "Zoom -"),
         (scale_button 0 "Zoom Reset"),
         (scale_button (1.15) "Zoom +"),
         (Html.button
            [
               (Html.Events.onClick Struct.Event.DebugTeamSwitchRequest)
            ]
            [ (Html.text "[DEBUG] Switch team") ]
         ),
         (Html.button
            [
               (Html.Events.onClick Struct.Event.DebugLoadBattleRequest)
            ]
            [ (Html.text "[DEBUG] Load map") ]
         ),
         (Html.button
            [
               (Html.Events.onClick Struct.Event.DebugTestAnimation)
            ]
            [ (Html.text "[DEBUG] Test animations") ]
         )
      ]
   )
