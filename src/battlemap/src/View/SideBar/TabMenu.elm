module View.SideBar.TabMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Html

import View.SideBar.TabMenu.Characters
import View.SideBar.TabMenu.Settings
import View.SideBar.TabMenu.Status

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_basic_button_html : Struct.UI.Tab -> (Html.Html Struct.Event.Type)
get_basic_button_html tab =
   (Html.button
      [ (Html.Events.onClick (Struct.Event.TabSelected tab)) ]
      [ (Html.text (Struct.UI.to_string tab)) ]
   )

get_menu_button_html : (
      Struct.UI.Tab ->
      Struct.UI.Tab ->
      (Html.Html Struct.Event.Type)
   )
get_menu_button_html selected_tab tab =
   (Html.button
      (
         if (tab == selected_tab)
         then
            [ (Html.Attributes.disabled True) ]
         else
            [ (Html.Events.onClick (Struct.Event.TabSelected tab)) ]
      )
      [ (Html.text (Struct.UI.to_string tab)) ]
   )

get_active_tab_selector_html : Struct.UI.Tab -> (Html.Html Struct.Event.Type)
get_active_tab_selector_html selected_tab =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tabmenu-selector")
      ]
      (List.map (get_menu_button_html selected_tab) (Struct.UI.get_all_tabs))
   )

get_inactive_tab_selector_html : (Html.Html Struct.Event.Type)
get_inactive_tab_selector_html =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tabmenu-selector")
      ]
      (List.map (get_basic_button_html) (Struct.UI.get_all_tabs))
   )

get_error_message_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_error_message_html model =
   case model.error of
      (Just error) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-tabmenu-error-message")
            ]
            [
               (Html.text (Struct.Error.to_string error))
            ]
         )

      Nothing -> Util.Html.nothing
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tabmenu")
      ]
      (
         (get_error_message_html model)
         ::
         (
            let
               displayed_tab = (Struct.UI.try_getting_displayed_tab model.ui)
            in
               case displayed_tab of
                  (Just Struct.UI.StatusTab) ->
                     [
                        (get_active_tab_selector_html Struct.UI.StatusTab),
                        (View.SideBar.TabMenu.Status.get_html model)
                     ]

                  (Just Struct.UI.CharactersTab) ->
                     [
                        (get_active_tab_selector_html Struct.UI.CharactersTab),
                        (View.SideBar.TabMenu.Characters.get_html model)
                     ]

                  (Just Struct.UI.SettingsTab) ->
                     [
                        (get_active_tab_selector_html Struct.UI.SettingsTab),
                        (View.SideBar.TabMenu.Settings.get_html model)
                     ]

                  Nothing -> [(get_inactive_tab_selector_html)]
         )
      )
   )
