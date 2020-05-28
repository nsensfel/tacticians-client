module View.SubMenu.Timeline exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Events
import Html.Lazy

-- Shared ----------------------------------------------------------------------
import Shared.Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.Puppeteer
import Struct.TurnResult

import View.SubMenu.Timeline.Attack
import View.SubMenu.Timeline.Movement
import View.SubMenu.Timeline.WeaponSwitch
import View.SubMenu.Timeline.PlayerVictory
import View.SubMenu.Timeline.PlayerDefeat
import View.SubMenu.Timeline.PlayerTurnStart

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_turn_result_html : (
      (Array.Array Struct.Character.Type) ->
      Int ->
      Struct.TurnResult.Type ->
      (Html.Html Struct.Event.Type)
   )
get_turn_result_html characters player_ix turn_result =
   case turn_result of
      (Struct.TurnResult.Targeted target) -> (Shared.Util.Html.nothing)
      (Struct.TurnResult.Moved movement) ->
         (View.SubMenu.Timeline.Movement.get_html
            characters
            player_ix
            movement
         )

      (Struct.TurnResult.Attacked attack) ->
         (View.SubMenu.Timeline.Attack.get_html
            characters
            player_ix
            attack
         )

      (Struct.TurnResult.SwitchedWeapon weapon_switch) ->
         (View.SubMenu.Timeline.WeaponSwitch.get_html
            characters
            player_ix
            weapon_switch
         )

      (Struct.TurnResult.PlayerWon pvict) ->
         (View.SubMenu.Timeline.PlayerVictory.get_html pvict)

      (Struct.TurnResult.PlayerLost pdefeat) ->
         (View.SubMenu.Timeline.PlayerDefeat.get_html pdefeat)

      (Struct.TurnResult.PlayerTurnStarted pturns) ->
         (View.SubMenu.Timeline.PlayerTurnStart.get_html pturns)

get_events_html : Struct.Battle.Type -> (Html.Html Struct.Event.Type)
get_events_html battle =
   (Html.div
      [
         (Html.Attributes.class "tabmenu-timeline-events")
      ]
      (Array.toList
         (Array.map
            (get_turn_result_html
               (Struct.Battle.get_characters battle)
               (Struct.Battle.get_own_player_index battle)
            )
            (Struct.Battle.get_timeline battle)
         )
      )
   )

get_skip_to_button : Bool -> (Html.Html Struct.Event.Type)
get_skip_to_button skip_forward =
   (Html.button
      [
         (Html.Attributes.class
            (
               if (skip_forward)
               then "skip_forward"
               else "skip_backward"
            )
         ),
         (Html.Events.onClick (Struct.Event.PuppeteerSkipTo skip_forward))
      ]
      [
      ]
   )

get_play_button : Bool -> Bool -> (Html.Html Struct.Event.Type)
get_play_button play_forward current_dir =
   (Html.button
      [
         (Html.Attributes.class
            (
               if (play_forward)
               then "play_forward"
               else "play_backward"
            )
         ),
         (
            if (play_forward == current_dir)
            then (Html.Attributes.class "active")
            else (Html.Events.onClick (Struct.Event.PuppeteerPlay play_forward))
         )
      ]
      [
      ]
   )

get_pause_button : Bool -> (Html.Html Struct.Event.Type)
get_pause_button is_paused =
   (Html.button
      [
         (Html.Attributes.class "pause"),
         (Html.Events.onClick Struct.Event.PuppeteerTogglePause),
         (Html.Attributes.class
            (
               if (is_paused)
               then "active"
               else ""
            )
         )
      ]
      [
      ]
   )

get_controls_html : Struct.Puppeteer.Type -> (Html.Html Struct.Event.Type)
get_controls_html puppeteer =
   let
      is_playing_forward = (Struct.Puppeteer.get_is_playing_forward puppeteer)
      is_paused = (Struct.Puppeteer.get_is_paused puppeteer)
   in
      (Html.div
         [
            (Html.Attributes.class "tabmenu-timeline-controls")
         ]
         [
            (get_skip_to_button False),
            (get_play_button False is_playing_forward),
            (get_pause_button is_paused),
            (get_play_button True is_playing_forward),
            (get_skip_to_button True)
         ]
      )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "tabmenu-content"),
         (Html.Attributes.class "tabmenu-timeline-tab")
      ]
      [
         (get_controls_html model.puppeteer),
         (Html.Lazy.lazy (get_events_html) model.battle)
      ]
   )
