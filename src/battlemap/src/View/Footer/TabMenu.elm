module View.Footer.TabMenu exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Event

import Model

import UI

import View.Footer.TabMenu.Characters
import View.Footer.TabMenu.Status
import View.Footer.TabMenu.Settings

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_basic_button_html : UI.Tab -> (Html.Html Event.Type)
get_basic_button_html tab =
   (Html.button
      [ (Html.Events.onClick (Event.TabSelected tab)) ]
      [ (Html.text (UI.to_string tab)) ]
   )

get_menu_button_html : UI.Tab -> UI.Tab -> (Html.Html Event.Type)
get_menu_button_html selected_tab tab =
   (Html.button
      (
         if (tab == selected_tab)
         then
            [ (Html.Attributes.disabled True) ]
         else
            [ (Html.Events.onClick (Event.TabSelected tab)) ]
      )
      [ (Html.text (UI.to_string tab)) ]
   )

get_active_tab_selector_html : UI.Tab -> (Html.Html Event.Type)
get_active_tab_selector_html selected_tab =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer-tabmenu-selector")
      ]
      (List.map (get_menu_button_html selected_tab) (UI.get_all_tabs))
   )

get_inactive_tab_selector_html : (Html.Html Event.Type)
get_inactive_tab_selector_html =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer-tabmenu-selector")
      ]
      (List.map (get_basic_button_html) (UI.get_all_tabs))
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer-tabmenu")
      ]
      (
         let
            displayed_tab = (UI.try_getting_displayed_tab model.ui)
         in
            case displayed_tab of
               (Just UI.StatusTab) ->
                  [
                     (get_active_tab_selector_html UI.StatusTab),
                     (View.Footer.TabMenu.Status.get_html model)
                  ]

               (Just UI.CharactersTab) ->
                  [
                     (get_active_tab_selector_html UI.CharactersTab),
                     (View.Footer.TabMenu.Characters.get_html model)
                  ]

               (Just UI.SettingsTab) ->
                  [
                     (get_active_tab_selector_html UI.SettingsTab),
                     (View.Footer.TabMenu.Settings.get_html model)
                  ]

               Nothing -> [(get_inactive_tab_selector_html)]
      )
   )
