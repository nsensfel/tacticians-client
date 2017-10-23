module View.Footer exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Event

import Model

import Util.Html

import UI

import View.Footer.TabMenu
import View.Footer.ManualControls

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer")
      ]
      [
         (View.Footer.TabMenu.get_html model),
         (
            if (UI.has_manual_controls_enabled model.ui)
            then
               (View.Footer.ManualControls.get_html)
            else
               (Util.Html.nothing)
         )
      ]
   )
