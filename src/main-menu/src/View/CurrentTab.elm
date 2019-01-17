module View.CurrentTab exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
--import Html.Attributes

-- Main Menu -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.Player
import Struct.UI

import View.BattleListing
import View.Invasions
import View.MapListing
import View.Roster

import View.Tab.NewBattle

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
default_tab : (Struct.Model.Type -> (Html.Html Struct.Event.Type))
default_tab model =
   (Html.main_
      [
      ]
      [
         (View.BattleListing.get_html
            "Campaigns"
            "main-menu-campaigns"
            (Array.toList (Struct.Player.get_campaigns model.player))
         ),
         (View.Invasions.get_html
            (Struct.Player.get_invasions model.player)
         ),
         (View.BattleListing.get_html
            "Events"
            "main-menu-events"
            (Array.toList (Struct.Player.get_events model.player))
         ),
         (View.MapListing.get_html
            (Array.toList (Struct.Player.get_maps model.player))
         ),
         (View.Roster.get_html)
      ]
   )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Struct.Model.Type -> (Html.Html Struct.Event.Type))
get_html model =
   case (Struct.UI.get_current_tab model.ui) of
      Struct.UI.DefaultTab -> (default_tab model)
      Struct.UI.NewBattleTab -> (View.Tab.NewBattle.get_html model)
