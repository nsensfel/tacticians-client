module View.MessageBoard.Animator.Attack exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Attack
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

get_empty_attack_html : (Html.Html Struct.Event.Type)
get_empty_attack_html =
   (Html.div
      [
         (Html.Attributes.class "battlemap-message-attack-text")
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
      attacker_name = (Struct.Character.get_name attacker)
      defender_name = (Struct.Character.get_name defender)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-message-attack-text")
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
   then
      "battlemap-animated-portrait-attack-critical"
   else
      "battlemap-animated-portrait-attacks"

get_defense_animation_class : (
      Struct.Attack.Type ->
      Struct.Character.Type ->
      String
   )
get_defense_animation_class attack char =
   if (attack.damage == 0)
   then
      if (attack.precision == Struct.Attack.Miss)
      then
         "battlemap-animated-portrait-dodges"
      else
         "battlemap-animated-portrait-undamaged"
   else if ((Struct.Character.get_current_health char) > 0)
   then
      if (attack.precision == Struct.Attack.Graze)
      then
         "battlemap-animated-portrait-grazed-damage"
      else
         "battlemap-animated-portrait-damaged"
   else
      if (attack.precision == Struct.Attack.Graze)
      then
         "battlemap-animated-portrait-grazed-death"
      else
         "battlemap-animated-portrait-dies"

get_attacker_card : (
      (Maybe Struct.Attack.Type) ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_attacker_card maybe_attack char =
   (Html.div
      (case maybe_attack of
         Nothing ->
            if ((Struct.Character.get_current_health char) > 0)
            then
               [
                  (Html.Attributes.class "battlemap-animated-portrait")
               ]
            else
               [
                  (Html.Attributes.class "battlemap-animated-portrait-absent"),
                  (Html.Attributes.class "battlemap-animated-portrait")
               ]

         (Just attack) ->
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
               (Html.Attributes.class "battlemap-animated-portrait")
            ]
      )
      [
         (View.Controlled.CharacterCard.get_minimal_html
            (Struct.Character.get_player_ix char)
            char
         )
      ]
   )

get_defender_card : (
      (Maybe Struct.Attack.Type) ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_defender_card maybe_attack char =
   (Html.div
      (case maybe_attack of
         Nothing ->
            if ((Struct.Character.get_current_health char) > 0)
            then
               [
                  (Html.Attributes.class "battlemap-animated-portrait")
               ]
            else
               [
                  (Html.Attributes.class "battlemap-animated-portrait-absent"),
                  (Html.Attributes.class "battlemap-animated-portrait")
               ]

         (Just attack) ->
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
               (Html.Attributes.class "battlemap-animated-portrait")
            ]
      )
      [
         (View.Controlled.CharacterCard.get_minimal_html -1 char)
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_placeholder_html : (
      (Array.Array Struct.Character.Type) ->
      Int ->
      Int ->
      (Maybe Struct.Attack.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_placeholder_html characters attacker_ix defender_ix maybe_attack =
   case
      (
         (Array.get attacker_ix characters),
         (Array.get defender_ix characters)
      )
   of
      ((Just atkchar), (Just defchar)) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-message-board"),
               (Html.Attributes.class "battlemap-message-attack")
            ]
            (
               [
                  (get_attacker_card maybe_attack atkchar),
                  (
                     case maybe_attack of
                        (Just attack) ->
                           (get_attack_html atkchar defchar attack)

                        Nothing ->
                           (get_empty_attack_html)
                  ),
                  (get_defender_card maybe_attack defchar)
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
      Int ->
      Int ->
      (Maybe Struct.Attack.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_html model attacker_ix defender_ix maybe_attack =
   (get_placeholder_html model.characters attacker_ix defender_ix maybe_attack)
