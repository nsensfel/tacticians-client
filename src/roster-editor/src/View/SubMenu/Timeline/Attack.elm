module View.SubMenu.Timeline.Attack exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
--import Html.Events

-- Map -------------------------------------------------------------------
import Struct.Attack
import Struct.Event
import Struct.TurnResult
import Struct.Character

import View.Character

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_title_html : (
      Struct.Character.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_title_html attacker defender =
   (Html.div
      [
         (Html.Attributes.class "battle-timeline-attack-title")
      ]
      [
         (Html.text
            (
               (Struct.Character.get_name attacker)
               ++ " attacked "
               ++ (Struct.Character.get_name defender)
               ++ "!"
            )
         )
      ]
   )

get_effect_text : Struct.Attack.Type -> String
get_effect_text attack =
   (
      (
         case attack.precision of
            Struct.Attack.Hit -> " hit for "
            Struct.Attack.Graze -> " grazed for "
            Struct.Attack.Miss -> " missed."
      )
      ++
      (
         if (attack.precision == Struct.Attack.Miss)
         then
            ""
         else
            (
               ((toString attack.damage) ++ " damage")
               ++
               (
                  if (attack.critical)
                  then " (Critical Hit)."
                  else "."
               )
            )
      )
   )

get_attack_html : (
      Struct.Character.Type ->
      Struct.Character.Type ->
      Struct.Attack.Type ->
      (Html.Html Struct.Event.Type)
   )
get_attack_html attacker defender attack =
   let
      attacker_name = (Struct.Character.get_name attacker)
      defender_name = (Struct.Character.get_name defender)
   in
   (Html.div
      []
      [
         (Html.text
            (
               case (attack.order, attack.parried) of
                  (Struct.Attack.Counter, True) ->
                     (
                        defender_name
                        ++ " attempted to strike back, but "
                        ++ attacker_name
                        ++ " parried, and "
                        ++ (get_effect_text attack)
                     )

                  (Struct.Attack.Counter, _) ->
                     (
                        defender_name
                        ++ " striked back, and "
                        ++ (get_effect_text attack)
                     )

                  (_, True) ->
                     (
                        attacker_name
                        ++ " attempted a hit, but "
                        ++ defender_name
                        ++ " parried, and "
                        ++ (get_effect_text attack)
                     )

                  (_, _) ->
                     (attacker_name ++ " " ++ (get_effect_text attack))
            )
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      (Array.Array Struct.Character.Type) ->
      Int ->
      Struct.TurnResult.Attack ->
      (Html.Html Struct.Event.Type)
   )
get_html characters player_ix attack =
   case
      (
         (Array.get attack.attacker_index characters),
         (Array.get attack.defender_index characters)
      )
   of
      ((Just atkchar), (Just defchar)) ->
         (Html.div
            [
               (Html.Attributes.class "battle-timeline-element"),
               (Html.Attributes.class "battle-timeline-attack")
            ]
            (
               [
                  (View.Character.get_portrait_html player_ix atkchar),
                  (View.Character.get_portrait_html player_ix defchar),
                  (get_title_html atkchar defchar)
               ]
               ++
               (List.map
                  (get_attack_html atkchar defchar)
                  attack.sequence
               )
            )
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "battle-timeline-element"),
               (Html.Attributes.class "battle-timeline-attack")
            ]
            [
               (Html.text "Error: Attack with unknown characters")
            ]
         )
