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
has_a_path : Struct.CharacterTurn.Type -> Bool
has_a_path char_turn =
   case (Struct.CharacterTurn.maybe_get_navigator char_turn) of
      (Just nav) -> ((Struct.Navigator.get_path nav) /= [])
      Nothing -> False


skill_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
skill_button char_turn =
   (Html.button
      [ (Html.Events.onClick Struct.Event.AttackRequest) ]
      [
         (Html.text
            (
               if (has_a_path char_turn)
               then ("Go & Select Skill Target(s)")
               else ("Select Skill Target(s)")
            )
         )
      ]
   )

attack_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
attack_button char_turn =
   (Html.button
      [ (Html.Events.onClick Struct.Event.AttackRequest) ]
      [
         (Html.text
            (
               if (has_a_path char_turn)
               then ("Go & Select Attack Target")
               else ("Select Attack Target")
            )
         )
      ]
   )

abort_button : (Html.Html Struct.Event.Type)
abort_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.AbortTurnRequest) ]
      [ (Html.text "Abort") ]
   )

undo_button : (Html.Html Struct.Event.Type)
undo_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.UndoActionRequest) ]
      [ (Html.text "Undo") ]
   )

end_turn_button : (Html.Html Struct.Event.Type)
end_turn_button =
   (Html.button
      [
         (Html.Events.onClick Struct.Event.TurnEnded),
         (Html.Attributes.class "end-turn-button")
      ]
      [ (Html.text ("Confirm Turn")) ]
   )

inventory_button : Bool -> (Html.Html Struct.Event.Type)
inventory_button go_prefix =
   (Html.button
      [ (Html.Events.onClick Struct.Event.WeaponSwitchRequest) ]
      [
         (Html.text
            (
               if (go_prefix)
               then ("Go & Switch Weapon")
               else ("Switch Weapon")
            )
         )
      ]
   )

get_available_actions : (
      Struct.CharacterTurn.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_available_actions char_turn =
   if ((Struct.CharacterTurn.get_action char_turn) == Struct.CharacterTurn.None)
   then
         [
            (attack_button char_turn),
            (skill_button char_turn),
            (inventory_button (has_a_path char_turn)),
            (end_turn_button),
            (abort_button)
         ]
   else
         [
            (end_turn_button),
            (undo_button),
            (abort_button)
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
               (
                  if
                  (
                     (Struct.CharacterTurn.get_action char_turn)
                     ==
                     Struct.CharacterTurn.None
                  )
                  then (View.Controlled.ManualControls.get_html)
                  else (Shared.Util.Html.nothing)
               ),
               (Html.div
                  [(Html.Attributes.class "controlled-actions")]
                  (get_available_actions char_turn)
               )
            ]
         )

      Nothing -> (Shared.Util.Html.nothing)
