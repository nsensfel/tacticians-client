module View.MainMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_menu_button_html : Struct.UI.Tab -> (Html.Html Struct.Event.Type)
get_menu_button_html tab =
   (Html.button
      [ (Html.Events.onClick (Struct.Event.TabSelected tab)) ]
      [ (Html.text (Struct.UI.to_string tab)) ]
   )

get_main_menu_button_html : (Html.Html Struct.Event.Type)
get_main_menu_button_html =
   (Html.button
      [ (Html.Events.onClick Struct.Event.GoToMainMenu) ]
      [ (Html.text "Main Menu") ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.div
      [
         (Html.Attributes.class "main-menu")
      ]
      (
         (get_main_menu_button_html)
         ::
         (List.map
            (get_menu_button_html)
            (Struct.UI.get_all_tabs)
         )
      )
   )
