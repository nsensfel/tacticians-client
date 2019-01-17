module View.Tab.NewBattle exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array
import List

import Html
import Html.Attributes
import Html.Events

-- Main Menu -------------------------------------------------------------------
import Struct.BattleRequest
import Struct.BattleSummary
import Struct.Event
import Struct.MapSummary
import Struct.Model
import Struct.Player
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
select_mode_html : (Html.Html Struct.Event.Type)
select_mode_html =
   (Html.div
      [
      ]
      [
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetMode
                     Struct.BattleSummary.Attack
                  )
               )
            ]
            [
               (Html.text "New Offensive")
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetMode
                     Struct.BattleSummary.Defend
                  )
               )
            ]
            [
               (Html.text "New Defense")
            ]
         )
      ]
   )

select_size_html : Struct.BattleRequest.Size -> (Html.Html Struct.Event.Type)
select_size_html max_size =
   (Html.div
      [
      ]
      [
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetSize
                     Struct.BattleRequest.Small
                  )
               )
            ]
            [
               (Html.text "Small")
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetSize
                     Struct.BattleRequest.Medium
                  )
               )
            ]
            [
               (Html.text "Medium")
            ]
         ),
         (Html.button
            [
               (Html.Events.onClick
                  (Struct.Event.BattleSetSize
                     Struct.BattleRequest.Large
                  )
               )
            ]
            [
               (Html.text "Large")
            ]
         )
      ]
   )

map_button_html : Struct.MapSummary.Type -> (Html.Html Struct.Event.Type)
map_button_html map_summary =
   (Html.button
      [
         (Html.Events.onClick (Struct.Event.BattleSetMap map_summary))
      ]
      [
         (Html.text (Struct.MapSummary.get_name map_summary))
      ]
   )

select_map_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
select_map_html model =
   (Html.div
      [
      ]
      (
         (Html.text "Map Selection:")
         ::
         (List.map
            (map_button_html)
            (Array.toList (Struct.Player.get_maps model.player))
         )
      )
   )

select_characters_html : (
      Struct.BattleRequest.Type ->
      (Html.Html Struct.Event.Type)
   )
select_characters_html battle_req =
   (Html.a
      [
         (Html.Attributes.href
            (
               "/roster-editor/"
               ++
               (Struct.BattleRequest.get_url_params battle_req)
            )
         )
      ]
      [
         (Html.text "Select Characters")
      ]
   )

new_invasion_html : (
      Struct.BattleRequest.Type ->
      Struct.Model.Type ->
      (Html.Html Struct.Event.Type)
   )
new_invasion_html battle_req model =
   case
      (
         (Struct.BattleRequest.get_mode battle_req),
         (Struct.BattleRequest.get_size battle_req)
      )
   of
      (Struct.BattleSummary.Attack, Nothing) ->
         (select_size_html Struct.BattleRequest.Large)

      (Struct.BattleSummary.Attack, _) ->
         (select_characters_html battle_req)

      (Struct.BattleSummary.Defend, Nothing) ->
         (select_map_html model)

      (Struct.BattleSummary.Defend, _) ->
         (select_characters_html battle_req)

      (_, _) ->
         (select_mode_html)

new_event_html : (
      Struct.BattleRequest.Type ->
      Struct.Model.Type ->
      (Html.Html Struct.Event.Type)
   )
new_event_html battle_req model =
   (Html.div
      [
      ]
      [
         (Html.text "Not available yet.")
      ]
   )

new_campaign_html : (
      Struct.BattleRequest.Type ->
      Struct.Model.Type ->
      (Html.Html Struct.Event.Type)
   )
new_campaign_html battle_req model =
   (Html.div
      [
      ]
      [
         (Html.text "Not available yet.")
      ]
   )

get_actual_html : (
      Struct.BattleRequest.Type ->
      Struct.Model.Type ->
      (Html.Html Struct.Event.Type)
   )
get_actual_html battle_req model =
   case (Struct.BattleRequest.get_category battle_req) of
      Struct.BattleSummary.Invasion -> (new_invasion_html battle_req model)
      Struct.BattleSummary.Event -> (new_event_html battle_req model)
      Struct.BattleSummary.Campaign -> (new_campaign_html battle_req model)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (Struct.UI.get_action model.ui) of
      Struct.UI.None ->
         -- TODO: explain & let the user go back to the main menu.
         (Html.text "Error.")

      (Struct.UI.NewBattle battle_req) ->
         (get_actual_html battle_req model)
