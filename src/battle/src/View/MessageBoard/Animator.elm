module View.MessageBoard.Animator exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Event
import Struct.TurnResult
import Struct.TurnResultAnimator

import View.MessageBoard.Animator.Attack

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_turn_result_html : (
      Struct.Battle.Type ->
      Struct.TurnResult.Type ->
      (Html.Html Struct.Event.Type)
   )
get_turn_result_html battle turn_result =
   case turn_result of
      (Struct.TurnResult.Attacked attack) ->
         (View.MessageBoard.Animator.Attack.get_html
            battle
            (Struct.TurnResult.get_actor_index turn_result)
            (Struct.TurnResult.get_attack_defender_index attack)
            (Struct.TurnResult.maybe_get_attack_next_step attack)
         )

      _ -> (Util.Html.nothing)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Battle.Type ->
      Struct.TurnResultAnimator.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html battle animator =
   case (Struct.TurnResultAnimator.get_current_animation animator) of
      (Struct.TurnResultAnimator.TurnResult turn_result) ->
         (get_turn_result_html battle turn_result)

      (Struct.TurnResultAnimator.AttackSetup (attacker_id, defender_id)) ->
         (View.MessageBoard.Animator.Attack.get_html
            battle
            attacker_id
            defender_id
            Nothing
         )

      _ -> (Util.Html.nothing)
