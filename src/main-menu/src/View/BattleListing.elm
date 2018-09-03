module View.BattleListing exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
-- import Html.Events

-- Map -------------------------------------------------------------------
import Struct.BattleSummary
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_item_html : Struct.BattleSummary.Type -> (Html.Html Struct.Event.Type)
get_item_html item =
   (Html.a
      [
         (Html.Attributes.href
            (
               "/battle/?id="
               ++ (Struct.BattleSummary.get_id item)
            )
         ),
         (
            if (Struct.BattleSummary.is_players_turn item)
            then
               (Html.Attributes.class "main-menu-battle-summary-is-active")
            else
               (Html.Attributes.class "main-menu-battle-summary-is-inactive")
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-summary-name")
            ]
            [
               (Html.text (Struct.BattleSummary.get_name item))
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-summary-date")
            ]
            [
               (Html.text (Struct.BattleSummary.get_last_edit item))
            ]
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      String ->
      String ->
      (List Struct.BattleSummary.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_html name class battle_summaries =
   (Html.div
      [
         (Html.Attributes.class class),
         (Html.Attributes.class "main-menu-battle-listing")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-listing-header")
            ]
            [
               (Html.text name)
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-listing-body")
            ]
            (List.map (get_item_html) battle_summaries)
         ),
         (Html.div
            [
               (Html.Attributes.class "main-menu-battle-listing-add-new")
            ]
            [
               (Html.text "New")
            ]
         )
      ]
   )
