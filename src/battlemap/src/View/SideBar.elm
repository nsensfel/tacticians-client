module View.SideBar exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.CharacterTurn
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
            case (Struct.CharacterTurn.get_target model.char_turn) of
               (Just target_ref) ->
                  (View.SideBar.Targets.get_html model target_ref)

               _ ->
               (Util.Html.nothing)
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
