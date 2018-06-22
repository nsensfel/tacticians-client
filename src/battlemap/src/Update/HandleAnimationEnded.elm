module Update.HandleAnimationEnded exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

import Delay

import Time

import Task

-- Battlemap -------------------------------------------------------------------
import Action.Scroll

import Struct.Character
import Struct.Event
import Struct.Model
import Struct.TurnResult
import Struct.TurnResultAnimator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
handle_char_focus : (
      Struct.Model.Type ->
      Struct.TurnResultAnimator.Type ->
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
handle_char_focus model animator char_index =
   case (Array.get char_index model.characters) of
      (Just char) ->
         if (Struct.TurnResultAnimator.waits_for_focus animator)
         then
            (
               model,
               (Cmd.batch
                  [
                     (Task.attempt
                        (Struct.Event.attempted)
                        (Action.Scroll.to
                           (Struct.Character.get_location char)
                           model.ui
                        )
                     ),
                     (Delay.after 2.0 Time.second Struct.Event.AnimationEnded)
                  ]
               )
            )
         else
            (
               model,
               (Cmd.batch
                  [
                     (Task.attempt
                        (Struct.Event.attempted)
                        (Action.Scroll.to
                           (Struct.Character.get_location char)
                           model.ui
                        )
                     ),
                     (Delay.after 0.3 Time.second Struct.Event.AnimationEnded)
                  ]
               )
            )


      _ ->
         (
            model,
            (Delay.after 1.0 Time.millisecond Struct.Event.AnimationEnded)
         )

prepare_next_animation : (
      Struct.Model.Type ->
      Struct.TurnResultAnimator.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
prepare_next_animation model animator =
   case (Struct.TurnResultAnimator.get_current_animation animator) of
      (Struct.TurnResultAnimator.Focus char_index) ->
         (handle_char_focus model animator char_index)

      (Struct.TurnResultAnimator.AttackSetup _) ->
         (
            model,
            (Delay.after 1.0 Time.second Struct.Event.AnimationEnded)
         )

      (Struct.TurnResultAnimator.TurnResult turn_result) ->
         case turn_result of
            (Struct.TurnResult.Attacked _) ->
               (
                  model,
                  (Delay.after 3.0 Time.second Struct.Event.AnimationEnded)
               )

            _ ->
               (
                  model,
                  (Delay.after 0.1 Time.second Struct.Event.AnimationEnded)
               )

      _ ->
         (
            model,
            (Delay.after 0.3 Time.second Struct.Event.AnimationEnded)
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   let
      new_model =
         (Struct.Model.apply_animator_step
            (Struct.Model.move_animator_to_next_step model)
         )
   in
      case new_model.animator of
         Nothing -> (new_model, Cmd.none)
         (Just animator) ->
            (prepare_next_animation new_model animator)
