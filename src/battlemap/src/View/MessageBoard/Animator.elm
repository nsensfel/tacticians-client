module View.MessageBoard.Animator exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.TurnResult
import Struct.TurnResultAnimator

import Util.Html

import View.MessageBoard.Animator.Attack

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_turn_result_html : (
      Struct.Model.Type ->
      Struct.TurnResult.Type ->
      (Html.Html Struct.Event.Type)
   )
get_turn_result_html model turn_result =
   case turn_result of
      (Struct.TurnResult.Attacked attack) ->
         (View.MessageBoard.Animator.Attack.get_html
            model
            (Struct.TurnResult.get_actor_index turn_result)
            (Struct.TurnResult.get_attack_defender_index attack)
            (Struct.TurnResult.maybe_get_attack_next_step attack)
         )

      _ -> (Util.Html.nothing)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.TurnResultAnimator.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model animator =
   case (Struct.TurnResultAnimator.get_current_animation animator) of
      (Struct.TurnResultAnimator.TurnResult turn_result) ->
         (get_turn_result_html model turn_result)

      (Struct.TurnResultAnimator.AttackSetup (attacker_id, defender_id)) ->
         (View.MessageBoard.Animator.Attack.get_html
            model
            attacker_id
            defender_id
            Nothing
         )

      _ -> (Util.Html.nothing)
