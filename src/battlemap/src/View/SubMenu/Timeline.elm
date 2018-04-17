module View.SubMenu.Timeline exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
--import Html.Events
import Html.Lazy

-- Battlemap -------------------------------------------------------------------
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
      Struct.Model.Type ->
      Struct.TurnResult.Type ->
      (Html.Html Struct.Event.Type)
   )
get_turn_result_html model turn_result =
   case turn_result of
      (Struct.TurnResult.Moved movement) ->
         (View.SubMenu.Timeline.Movement.get_html model movement)

      (Struct.TurnResult.Attacked attack) ->
         (View.SubMenu.Timeline.Attack.get_html model attack)

      (Struct.TurnResult.SwitchedWeapon weapon_switch) ->
         (View.SubMenu.Timeline.WeaponSwitch.get_html
            model
            weapon_switch
         )

true_get_html : (
      Struct.Model.Type ->
      (Array.Array Struct.TurnResult.Type) ->
      (Html.Html Struct.Event.Type)
   )
true_get_html model turn_results =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tabmenu-content"),
         (Html.Attributes.class "battlemap-tabmenu-timeline-tab")
      ]
      (Array.toList
         (Array.map
            (get_turn_result_html model)
            turn_results
         )
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.Lazy.lazy (true_get_html model) model.timeline)
