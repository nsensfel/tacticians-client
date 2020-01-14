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

get_attack_animation_class : (
      Struct.Attack.Type ->
      Struct.Character.Type ->
      String
   )
get_attack_animation_class attack char =
   if (attack.critical)
   then "animated-portrait-attack-critical"
   else "animated-portrait-attacks"

get_defense_animation_class : (
      Struct.Attack.Type ->
      Struct.Character.Type ->
      String
   )
get_defense_animation_class attack char =
   if (attack.damage == 0)
   then
      if (attack.precision == Struct.Attack.Miss)
      then "animated-portrait-dodges"
      else "animated-portrait-undamaged"
   else if ((Struct.Character.get_current_health char) > 0)
   then
      if (attack.precision == Struct.Attack.Graze)
      then "animated-portrait-grazed-damage"
      else "animated-portrait-damaged"
   else
      if (attack.precision == Struct.Attack.Graze)
      then "animated-portrait-grazed-death"
      else "animated-portrait-dies"

get_attacker_card : (
      Struct.Attack.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_attacker_card attack char =
   (Html.div
      [
         (Html.Attributes.class
            (case (attack.order, attack.parried) of
               (Struct.Attack.Counter, True) ->
                  (get_attack_animation_class attack char)

               (Struct.Attack.Counter, _) ->
                  (get_defense_animation_class attack char)

               (_, True) ->
                  (get_defense_animation_class attack char)

               (_, _) ->
                  (get_attack_animation_class attack char)
            )
         ),
         (Html.Attributes.class "animated-portrait")
      ]
      [
         (View.Controlled.CharacterCard.get_minimal_html
            (Struct.Character.get_player_index char)
            char
         )
      ]
   )

get_defender_card : (
      Struct.Attack.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_defender_card attack char =
   (Html.div
      [
         (Html.Attributes.class
            (case (attack.order, attack.parried) of
               (Struct.Attack.Counter, True) ->
                  (get_defense_animation_class attack char)

               (Struct.Attack.Counter, _) ->
                  (get_attack_animation_class attack char)

               (_, True) ->
                  (get_attack_animation_class attack char)

               (_, _) ->
                  (get_defense_animation_class attack char)
            )
         ),
         (Html.Attributes.class "animated-portrait")
      ]
      [
         (View.Controlled.CharacterCard.get_minimal_html -1 char)
      ]
   )

get_placeholder_html : (
      (Array.Array Struct.Character.Type) ->
      Int ->
      Int ->
      Struct.Attack.Type ->
      (Html.Html Struct.Event.Type)
   )
get_placeholder_html characters attacker_ix defender_ix attack =
   case
      (
         (Array.get attacker_ix characters),
         (Array.get defender_ix characters)
      )
   of
      ((Just atkchar), (Just defchar)) ->
         (Html.div
            [
               (Html.Attributes.class "message-board"),
               (Html.Attributes.class "message-attack")
            ]
            (
               [
                  (get_attacker_card attack atkchar),
                  (get_attack_html atkchar defchar attack),
                  (get_defender_card attack defchar)
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
      (Struct.Battle.get_characters model.battle)
      0 -- TODO: get attacker IX
      0 -- TODO: get defender IX
      attack
   )
