module View.SideBar.TabMenu.Timeline.Attack exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
--import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Attack
import Struct.Event
import Struct.TurnResult
import Struct.Character
import Struct.Model

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
         (Html.Attributes.class "battlemap-timeline-attack-title")
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

get_portrait_html : (
      Struct.Character.Type ->
      Bool ->
      (Html.Html Struct.Event.Type)
   )
get_portrait_html char float_left =
   (Html.div
      [
         (Html.Attributes.class "battlemap-timeline-portrait"),
         (
            if (float_left)
            then
               (Html.Attributes.class "battlemap-float-left")
            else
               (Html.Attributes.class "battlemap-float-right")
         ),
         (Html.Attributes.class
            (
               "asset-character-portrait-"
               ++ (Struct.Character.get_portrait_id char)
            )
         )
      ]
      [
      ]
   )

get_effect_text : Struct.Attack.Type -> String
get_effect_text attack =
   (
      (
         case attack.precision of
            Struct.Attack.Hit -> " hits for "
            Struct.Attack.Graze -> " grazes for "
            Struct.Attack.Miss -> " misses."
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
                  then " (Critical)."
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
                        ++ " attempts to strike back, but "
                        ++ attacker_name
                        ++ " parries, and "
                        ++ (get_effect_text attack)
                     )

                  (Struct.Attack.Counter, _) ->
                     (
                        defender_name
                        ++ " strikes back, and "
                        ++ (get_effect_text attack)
                     )

                  (_, True) ->
                     (
                        attacker_name
                        ++ " attempts a hit, but "
                        ++ defender_name
                        ++ " parries, and "
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
      Struct.Model.Type ->
      Struct.TurnResult.Attack ->
      (Html.Html Struct.Event.Type)
   )
get_html model attack =
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
            (
               [
                  (get_portrait_html atkchar True),
                  (get_portrait_html defchar False),
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
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-attack")
            ]
            [
               (Html.text "Error: Attack with unknown characters")
            ]
         )
