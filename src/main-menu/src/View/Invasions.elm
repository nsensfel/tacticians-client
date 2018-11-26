module View.Invasions exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Events

-- Main Menu -------------------------------------------------------------------
import Struct.BattleSummary
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_invasion_html : (
      Int ->
      Struct.BattleSummary.Type ->
      (Html.Html Struct.Event.Type)
   )
get_invasion_html ix invasion =
   let
      invasion_id = (Struct.BattleSummary.get_id invasion)
      activation_class =
         (
            if (Struct.BattleSummary.is_players_turn invasion)
            then (Html.Attributes.class "main-menu-battle-summary-is-active")
            else (Html.Attributes.class "main-menu-battle-summary-is-inactive")
         )
      invasion_type =
         (
            if (ix >= 3)
            then (Html.Attributes.class "main-menu-invasion-defense")
            else (Html.Attributes.class "main-menu-invasion-attack")
         )
   in
      if (invasion_id == "")
      then
         (Html.a
            [
               (Html.Events.onClick (Struct.Event.NewInvasion ix)),
               invasion_type
            ]
            [
               (Html.text "New Invasion")
            ]
         )
      else
         (Html.a
            [
               (Html.Attributes.href ("/battle/?id=" ++ invasion_id)),
               invasion_type,
               activation_class
            ]
            [
               (Html.div
                  [
                     (Html.Attributes.class "main-menu-battle-summary-name")
                  ]
                  [
                     (Html.text (Struct.BattleSummary.get_name invasion))
                  ]
               ),
               (Html.div
                  [
                     (Html.Attributes.class "main-menu-battle-summary-date")
                  ]
                  [
                     (Html.text (Struct.BattleSummary.get_last_edit invasion))
                  ]
               )
            ]
         )


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      (Array.Array Struct.BattleSummary.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_html invasions =
   (Html.div
      [
         (Html.Attributes.class "main-menu-invasions"),
         (Html.Attributes.class "main-menu-battle-listing")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-listing-header")
            ]
            [
               (Html.text "Invasions")
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-listing-body")
            ]
            (Array.toList (Array.indexedMap (get_invasion_html) invasions))
         )
      ]
   )
