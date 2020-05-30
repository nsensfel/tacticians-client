module View.MessageBoard.Attack exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
import Struct.Attack
import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model

import View.Controlled.CharacterCard

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_effect_text : Struct.Attack.Type -> String
get_effect_text attack =
   let precision = (Struct.Attack.get_precision attack) in
   (
      (
         case precision of
            Struct.Attack.Hit -> " hit for "
            Struct.Attack.Graze -> " grazed for "
            Struct.Attack.Miss -> " missed."
      )
      ++
      (
         if (precision == Struct.Attack.Miss)
         then
            ""
         else
            (
               ((String.fromInt (Struct.Attack.get_damage attack)) ++ " damage")
               ++
               (
                  if (Struct.Attack.get_is_a_critical attack)
                  then " (Critical Hit)."
                  else "."
               )
            )
      )
   )

get_empty_attack_html : (Html.Html Struct.Event.Type)
get_empty_attack_html =
   (Html.div
      [
         (Html.Attributes.class "message-attack-text")
      ]
      []
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
         [
            (Html.Attributes.class "message-attack-text")
         ]
         [
            (Html.text
               (
                  case
                     (
                        (Struct.Attack.get_order attack),
                        (Struct.Attack.get_is_a_parry attack)
                     )
                  of
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
                           attacker_name
                           ++ " striked back, and "
                           ++ (get_effect_text attack)
                        )

                     (_, True) ->
                        (
                           defender_name
                           ++ " attempted a hit, but "
                           ++ attacker_name
                           ++ " parried, and "
                           ++ (get_effect_text attack)
                        )

                     (_, _) ->
                        (attacker_name ++ " " ++ (get_effect_text attack))
               )
            )
         ]
      )

get_attack_animation_class : (
      Struct.Attack.Type ->
      Struct.Character.Type ->
      String
   )
get_attack_animation_class attack char =
   if (Struct.Attack.get_is_a_critical attack)
   then "animated-portrait-attack-critical"
   else "animated-portrait-attacks"

get_defense_animation_class : (
      Struct.Attack.Type ->
      Struct.Character.Type ->
      String
   )
get_defense_animation_class attack char =
   if ((Struct.Attack.get_damage attack) == 0)
   then
      if ((Struct.Attack.get_precision attack) == Struct.Attack.Miss)
      then "animated-portrait-dodges"
      else "animated-portrait-undamaged"
   else if ((Struct.Character.get_current_health char) > 0)
   then
      if ((Struct.Attack.get_precision attack) == Struct.Attack.Graze)
      then "animated-portrait-grazed-damage"
      else "animated-portrait-damaged"
   else
      if ((Struct.Attack.get_precision attack) == Struct.Attack.Graze)
      then "animated-portrait-grazed-death"
      else "animated-portrait-dies"

get_attacker_card : (
      Bool ->
      Struct.Attack.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_attacker_card keep_positions attack char =
   (Html.div
      [
         (Html.Attributes.class "animated-portrait"),
         (Html.Attributes.class (get_attack_animation_class attack char)),
         (Html.Attributes.class
            (
               if (keep_positions)
               then "initial-attacker"
               else "initial-target"
            )
         )
      ]
      [
         (View.Controlled.CharacterCard.get_minimal_html
            -1
            char
         )
      ]
   )

get_defender_card : (
      Bool ->
      Struct.Attack.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_defender_card keep_positions attack char =
   (Html.div
      [
         (Html.Attributes.class "animated-portrait"),
         (Html.Attributes.class (get_defense_animation_class attack char)),
         (Html.Attributes.class
            (
               if (keep_positions)
               then "initial-target"
               else "initial-attacker"
            )
         )
      ]
      [
         (View.Controlled.CharacterCard.get_minimal_html -1 char)
      ]
   )

get_placeholder_html : (
      Struct.Attack.Type ->
      (Array.Array Struct.Character.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_placeholder_html attack characters =
   let
      keep_positions =
         (
            ((Struct.Attack.get_order attack) == Struct.Attack.Counter)
            == (Struct.Attack.get_is_a_parry attack)
         )
   in
      case
         (
            (Array.get (Struct.Attack.get_actor_index attack) characters),
            (Array.get (Struct.Attack.get_target_index attack) characters)
         )
      of
         ((Just atkchar), (Just defchar)) ->
            (Html.div
               [
                  (Html.Attributes.class "message-board"),
                  (Html.Attributes.class "message-attack")
               ]
               (
                  if (keep_positions)
                  then
                     [
                        (get_attacker_card keep_positions attack atkchar),
                        (get_attack_html atkchar defchar attack),
                        (get_defender_card keep_positions attack defchar)
                     ]
                  else
                     [
                        (get_defender_card keep_positions attack defchar),
                        (get_attack_html atkchar defchar attack),
                        (get_attacker_card keep_positions attack atkchar)
                     ]
               )
            )

         _ ->
            (Html.div
               [
               ]
               [
                  (Html.text "Error: Attack with unknown characters")
               ]
            )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.Attack.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model attack =
   (get_placeholder_html
      attack
      (Struct.Battle.get_characters model.battle)
   )
