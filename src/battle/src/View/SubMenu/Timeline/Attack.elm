module View.SubMenu.Timeline.Attack exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
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
         (Html.Attributes.class "timeline-attack-title")
      ]
      [
         (Html.text
            (
               (BattleCharacters.Struct.Character.get_name
                  (Struct.Character.get_base_character attacker)
               )
               ++ " attacked "
               ++
               (BattleCharacters.Struct.Character.get_name
                  (Struct.Character.get_base_character defender)
               )
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
               ((String.fromInt attack.damage) ++ " damage")
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
      attacker_name =
         (BattleCharacters.Struct.Character.get_name
            (Struct.Character.get_base_character attacker)
         )
      defender_name =
         (BattleCharacters.Struct.Character.get_name
            (Struct.Character.get_base_character defender)
         )
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
               (Html.Attributes.class "timeline-element"),
               (Html.Attributes.class "timeline-attack")
            ]
            [
               (View.Character.get_portrait_html atkchar),
               (View.Character.get_portrait_html defchar),
               (get_title_html atkchar defchar),
               (get_attack_html
                  atkchar
                  defchar
                  (Struct.TurnResult.get_attack_data attack)
               )
            ]
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "timeline-element"),
               (Html.Attributes.class "timeline-attack")
            ]
            [
               (Html.text "Error: Attack with unknown characters")
            ]
         )
