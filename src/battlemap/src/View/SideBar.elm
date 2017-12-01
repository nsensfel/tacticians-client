module View.SideBar exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Event

import Model

import Util.Html

import UI

import View.SideBar.TabMenu
import View.SideBar.Targets
import View.SideBar.ManualControls

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-side-bar")
      ]
      [
         (View.SideBar.TabMenu.get_html model),
         (
            if (model.targets == [])
            then
               (Util.Html.nothing)
            else
               (View.SideBar.Targets.get_html model)
         ),
         (
            if (UI.has_manual_controls_enabled model.ui)
            then
               (View.SideBar.ManualControls.get_html)
            else
               (Util.Html.nothing)
         )
      ]
   )
