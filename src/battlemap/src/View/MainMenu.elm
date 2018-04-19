module View.MainMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_menu_button_html : (
      (Maybe Struct.UI.Tab) ->
      Struct.UI.Tab ->
      (Html.Html Struct.Event.Type)
   )
get_menu_button_html selected_tab tab =
   (Html.button
--      (
--         if ((Just tab) == selected_tab)
--         then
--            [ (Html.Attributes.disabled True) ]
--         else
            [ (Html.Events.onClick (Struct.Event.TabSelected tab)) ]
--      )
      [ (Html.text (Struct.UI.to_string tab)) ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-main-menu")
      ]
      (List.map
         (get_menu_button_html (Struct.UI.try_getting_displayed_tab model.ui))
         (Struct.UI.get_all_tabs)
      )
   )
