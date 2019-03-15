module View.MainMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Events

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
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
      [
         (Html.Events.onClick
            (Struct.Event.TabSelected Struct.UI.CharacterSelectionTab)
         )
      ]
      [ (Html.text "Characters") ]
   )

get_reset_button_html : (Html.Html Struct.Event.Type)
get_reset_button_html =
   (Html.button
      [  ]
      [ (Html.text "Reset") ]
   )

get_save_button_html : (Html.Html Struct.Event.Type)
get_save_button_html =
   (Html.button
      [ (Html.Events.onClick Struct.Event.SaveRequest) ]
      [
         (Html.text "Save")
      ]
   )

get_go_button_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_go_button_html model =
   if ((Array.length model.battle_order) > 0)
   then
      (Html.button
         [
            (Html.Events.onClick Struct.Event.GoRequest),
            (Html.Attributes.class "blinking")
         ]
         [
            (Html.text "Go!")
         ]
      )
   else
      (Util.Html.nothing)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "main-menu")
      ]
      [
         (get_main_menu_button_html),
         (get_reset_button_html),
         (get_characters_button_html),
         (get_save_button_html),
         (get_go_button_html model)
      ]
   )
