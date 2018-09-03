module ElmModule.View exposing (view)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Lazy
import Html.Attributes

-- Main Menu -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Player
import Struct.UI

import Util.Html

import View.BattleListing
import View.Header

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
         (View.Header.get_html),
         (Html.main_
            [
            ]
            [
               (View.BattleListing.get_html
                  "Campaigns"
                  "main-menu-campaigns"
                  (Struct.Player.get_campaigns model.player)
               ),
               (View.BattleListing.get_html
                  "Invasions"
                  "main-menu-invasions"
                  (Struct.Player.get_invasions model.player)
               ),
               (View.BattleListing.get_html
                  "Events"
                  "main-menu-events"
                  (Struct.Player.get_events model.player)
               )
            ]
         )
      ]
   )
