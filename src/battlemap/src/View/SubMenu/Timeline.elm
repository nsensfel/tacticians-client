module View.SubMenu.Timeline exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
--import Html.Events
import Html.Lazy

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.TurnResult
import Struct.Model

import View.SubMenu.Timeline.Attack
import View.SubMenu.Timeline.Movement
import View.SubMenu.Timeline.WeaponSwitch

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_turn_result_html : (
      (Array.Array Struct.Character.Type) ->
      String ->
      Struct.TurnResult.Type ->
      (Html.Html Struct.Event.Type)
   )
get_turn_result_html characters player_id turn_result =
   case turn_result of
      (Struct.TurnResult.Moved movement) ->
         (View.SubMenu.Timeline.Movement.get_html
            characters
            player_id
            movement
         )

      (Struct.TurnResult.Attacked attack) ->
         (View.SubMenu.Timeline.Attack.get_html
            characters
            player_id
            attack
         )

      (Struct.TurnResult.SwitchedWeapon weapon_switch) ->
         (View.SubMenu.Timeline.WeaponSwitch.get_html
            characters
            player_id
            weapon_switch
         )

true_get_html : (
      (Array.Array Struct.Character.Type) ->
      String ->
      (Array.Array Struct.TurnResult.Type) ->
      (Html.Html Struct.Event.Type)
   )
true_get_html characters player_id turn_results =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tabmenu-content"),
         (Html.Attributes.class "battlemap-tabmenu-timeline-tab")
      ]
      (Array.toList
         (Array.map
            (get_turn_result_html characters player_id)
            turn_results
         )
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.Lazy.lazy3
      (true_get_html)
      model.characters
      model.player_id
      model.timeline
   )
