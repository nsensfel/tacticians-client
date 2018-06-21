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

import Util.Html

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
               (Html.Attributes.class "battlemap-help")
            ]
            (
               [
                  (View.Controlled.CharacterCard.get_minimal_html
                     (Struct.Character.get_player_id atkchar)
                     atkchar
                  ),
                  (
                     case maybe_attack of
                        (Just attack) ->
                           (get_attack_html atkchar defchar attack)

                        Nothing ->
                           (Util.Html.nothing)
                  ),
                  (View.Controlled.CharacterCard.get_minimal_html "" defchar)
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
