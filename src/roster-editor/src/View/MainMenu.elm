module View.MainMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_main_menu_button_html : (Html.Html Struct.Event.Type)
get_main_menu_button_html =
   (Html.button
      [ (Html.Events.onClick Struct.Event.GoToMainMenu) ]
      [ (Html.text "Main Menu") ]
   )

get_characters_button_html : (Html.Html Struct.Event.Type)
get_characters_button_html =
   (Html.button
      [ (Html.Events.onClick Struct.Event.GoToMainMenu) ]
      [ (Html.text "Characters") ]
   )

get_reset_button_html : (Html.Html Struct.Event.Type)
get_reset_button_html =
   (Html.button
      [ ]
      [ (Html.text "Reset") ]
   )

get_save_button_html : (Html.Html Struct.Event.Type)
get_save_button_html =
   (Html.button
      [ ]
      [ (Html.text "Save") ]
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
      [
         (get_main_menu_button_html),
         (get_reset_button_html),
         (get_characters_button_html),
         (get_save_button_html)
      ]
   )
