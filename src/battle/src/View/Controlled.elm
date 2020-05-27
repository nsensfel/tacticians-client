module View.Controlled exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Shared ----------------------------------------------------------------------
import Shared.Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Event
import Struct.Navigator

import View.Controlled.CharacterCard
import View.Controlled.ManualControls

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
action_to_class : (
      Struct.CharacterTurn.Action ->
      (Html.Attribute Struct.Event.Type)
   )
action_to_class action =
   (Html.Attributes.class
      (
         case action of
            Struct.CharacterTurn.None -> "no-action"
            Struct.CharacterTurn.Skipping -> "skipping"
            Struct.CharacterTurn.Attacking -> "attacking"
            Struct.CharacterTurn.SwitchingWeapons -> "switching-weapons"
            Struct.CharacterTurn.UsingSkill -> "using-skill"
      )
   )

action_or_undo_button : (
      Struct.CharacterTurn.Action ->
      Struct.CharacterTurn.Action ->
      Struct.Event.Type ->
      (Html.Html Struct.Event.Type)
   )
action_or_undo_button current_action relevant_action event =
   (Html.button
      (
         if (current_action == Struct.CharacterTurn.None)
         then
            [
               (Html.Attributes.class "action-button"),
               (action_to_class relevant_action),
               (Html.Attributes.class "action"),
               (Html.Events.onClick event)
            ]
         else if (current_action == relevant_action)
         then
            [
               (Html.Attributes.class "action-button"),
               (action_to_class relevant_action),
               (Html.Events.onClick Struct.Event.UndoActionRequest),
               (Html.Attributes.class "undo")
            ]
         else
            [
               (Html.Attributes.class "action-button"),
               (action_to_class relevant_action),
               (Html.Attributes.class "disabled")
            ]
      )
      [
      ]
   )

inventory_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
inventory_button char_turn =
   (action_or_undo_button
      (Struct.CharacterTurn.get_action char_turn)
      Struct.CharacterTurn.SwitchingWeapons
      Struct.Event.WeaponSwitchRequest
   )


attack_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
attack_button char_turn =
   (action_or_undo_button
      (Struct.CharacterTurn.get_action char_turn)
      Struct.CharacterTurn.Attacking
      Struct.Event.AttackRequest
   )

skip_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
skip_button char_turn =
   (action_or_undo_button
      (Struct.CharacterTurn.get_action char_turn)
      Struct.CharacterTurn.Skipping
      Struct.Event.SkipRequest
   )

skill_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
skill_button char_turn =
   (action_or_undo_button
      (Struct.CharacterTurn.get_action char_turn)
      Struct.CharacterTurn.UsingSkill
      Struct.Event.SkillRequest
   )

abort_button : (Html.Html Struct.Event.Type)
abort_button =
   (Html.button
      [
         (Html.Attributes.class "action-button"),
         (Html.Events.onClick Struct.Event.AbortTurnRequest),
         (Html.Attributes.class "abort-button")
      ]
      [
      ]
   )


path_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
path_button char_turn =
   (Html.button
      (
         if
         (
            (
               (Struct.CharacterTurn.get_action char_turn)
               == Struct.CharacterTurn.None
            )
            &&
            (
               case (Struct.CharacterTurn.maybe_get_navigator char_turn) of
                  Nothing -> False
                  (Just nav) -> ((Struct.Navigator.get_path nav) /= [])
            )
         )
         then
            if ((Struct.CharacterTurn.get_path char_turn) == [])
            then
               [
                  (Html.Attributes.class "action-button"),
                  (Html.Attributes.class "path-button"),
                  (Html.Events.onClick Struct.Event.MoveRequest)
               ]
            else
               [
                  (Html.Attributes.class "action-button"),
                  (Html.Attributes.class "path-button"),
                  (Html.Events.onClick Struct.Event.UndoActionRequest),
                  (Html.Attributes.class "undo")
               ]
         else
            [
               (Html.Attributes.class "action-button"),
               (Html.Attributes.class "path-button"),
               (Html.Attributes.class "disabled"),
               (Html.Attributes.class
                  (
                     if ((Struct.CharacterTurn.get_path char_turn) == [])
                     then ""
                     else "undo"
                  )
               )
            ]
      )
      [
      ]
   )

end_turn_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
end_turn_button char_turn =
   let
      registered_path = (Struct.CharacterTurn.get_path char_turn)
      action =  (Struct.CharacterTurn.get_action char_turn)
      temporary_path =
         case (Struct.CharacterTurn.maybe_get_navigator char_turn) of
            Nothing -> []
            (Just nav) -> (Struct.Navigator.get_path nav)
   in
      (Html.button
         [
            (
               if
               (
                  (temporary_path /= registered_path)
                  ||
                  (
                     (Struct.CharacterTurn.is_aiming_at_something char_turn)
                     && (action /= Struct.CharacterTurn.Attacking)
                     && (action /= Struct.CharacterTurn.UsingSkill)
                  )
                  ||
                  (
                     (registered_path == [])
                     && (action == Struct.CharacterTurn.None)
                  )
               )
               then (Html.Attributes.class "disabled")
               else (Html.Events.onClick Struct.Event.TurnEnded)
            ),
            (Html.Attributes.class "action-button"),
            (Html.Attributes.class "end-turn-button"),
            (Html.Attributes.class
               (
                  if (registered_path == [])
                  then "no-path-was-queued"
                  else "path-was-queued"
               )
            ),
            (action_to_class (Struct.CharacterTurn.get_action char_turn))
         ]
         [
         ]
      )

get_available_actions : (
      Struct.CharacterTurn.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_available_actions char_turn =
   [
      (abort_button),
      (skip_button char_turn),
      (path_button char_turn),
      (attack_button char_turn),
      (skill_button char_turn),
      (inventory_button char_turn),
      (end_turn_button char_turn)
   ]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.CharacterTurn.Type -> Int -> (Html.Html Struct.Event.Type)
get_html char_turn player_ix =
   case
      (Struct.CharacterTurn.maybe_get_active_character char_turn)
   of
      (Just char) ->
         (Html.div
            [(Html.Attributes.class "controlled")]
            [
               (View.Controlled.CharacterCard.get_summary_html
                  char_turn
                  player_ix
                  char
               ),
               (Html.div
                  [
                     (Html.Attributes.class "controlled-controls")
                  ]
                  [
                     (Html.div
                        [(Html.Attributes.class "controlled-actions")]
                        (get_available_actions char_turn)
                     ),
                     (
                        if
                        (
                           (Struct.CharacterTurn.get_action char_turn)
                           ==
                           Struct.CharacterTurn.None
                        )
                        then (View.Controlled.ManualControls.get_html)
                        else (Shared.Util.Html.nothing)
                     )
                  ]
               )
            ]
         )

      Nothing -> (Shared.Util.Html.nothing)
