module View.SideBar exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Html


import View.SideBar.TabMenu
import View.SideBar.Targets
import View.SideBar.ManualControls

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
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
            if (Struct.UI.has_manual_controls_enabled model.ui)
            then
               (View.SideBar.ManualControls.get_html)
            else
               (Util.Html.nothing)
         )
      ]
   )
