module View.SideBar.TabMenu.Timeline exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Html
import Html.Attributes
--import Html.Events
import Html.Lazy

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.TurnResult
import Struct.Character
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_attack_html : (
      Struct.Model.Type ->
      Struct.TurnResult.Attack ->
      (Html.Html Struct.Event.Type)
   )
get_attack_html model attack =
   case
      (
         (Dict.get (toString attack.attacker_index) model.characters),
         (Dict.get (toString attack.defender_index) model.characters)
      )
   of
      ((Just atkchar), (Just defchar)) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-attack")
            ]
            [
               (Html.text
                  (
                     (Struct.Character.get_name atkchar)
                     ++ " attacked "
                     ++ (Struct.Character.get_name defchar)
                     ++ "!"
                  )
               )
            ]
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-attack")
            ]
            [
               (Html.text "Error: Attack with unknown characters")
            ]
         )

get_movement_html : (
      Struct.Model.Type ->
      Struct.TurnResult.Movement ->
      (Html.Html Struct.Event.Type)
   )
get_movement_html model movement =
   case (Dict.get (toString movement.character_index) model.characters) of
      (Just char) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-movement")
            ]
            [
               (Html.text
                  (
                     (Struct.Character.get_name char)
                     ++ " moved to ("
                     ++ (toString movement.destination.x)
                     ++ ", "
                     ++ (toString movement.destination.y)
                     ++ ")."
                  )
               )
            ]
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-movement")
            ]
            [
               (Html.text "Error: Moving with unknown character")
            ]
         )

get_weapon_switch_html : (
      Struct.Model.Type ->
      Struct.TurnResult.WeaponSwitch ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_switch_html model weapon_switch =
   case (Dict.get (toString weapon_switch.character_index) model.characters) of
      (Just char) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-weapon-switch")
            ]
            [
               (Html.text
                  (
                     (Struct.Character.get_name char)
                     ++ " switched weapons."
                  )
               )
            ]
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-weapon-switch")
            ]
            [
               (Html.text "Error: Unknown character switched weapons")
            ]
         )

get_turn_result_html : (
      Struct.Model.Type ->
      Struct.TurnResult.Type ->
      (Html.Html Struct.Event.Type)
   )
get_turn_result_html model turn_result =
   case turn_result of
      (Struct.TurnResult.Moved movement) ->
         (get_movement_html model movement)

      (Struct.TurnResult.Attacked attack) ->
         (get_attack_html model attack)

      (Struct.TurnResult.SwitchedWeapon weapon_switch) ->
         (get_weapon_switch_html model weapon_switch)

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
