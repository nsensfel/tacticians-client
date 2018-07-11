module Struct.TurnResultAnimator exposing
   (
      Type,
      Animation(..),
      maybe_new,
      maybe_trigger_next_step,
      waits_for_focus,
      get_current_animation
   )

-- Elm -------------------------------------------------------------------------

-- Map -------------------------------------------------------------------
import Struct.TurnResult

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

type Animation =
   Inactive
   | AttackSetup (Int, Int)
   | Focus Int
   | TurnResult Struct.TurnResult.Type

type alias Type =
   {
      remaining_animations : (List Animation),
      current_animation : Animation,
      wait_focus : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
turn_result_to_animations : Struct.TurnResult.Type -> (List Animation)
turn_result_to_animations turn_result =
   case turn_result of
      (Struct.TurnResult.Attacked attack) ->
         let
            attacker_ix = (Struct.TurnResult.get_actor_index turn_result)
            defender_ix = (Struct.TurnResult.get_attack_defender_index attack)
         in
            [
               (Focus attacker_ix),
               (Focus defender_ix),
               (AttackSetup (attacker_ix, defender_ix)),
               (TurnResult turn_result)
            ]

      _ ->
         [
            (Focus (Struct.TurnResult.get_actor_index turn_result)),
            (TurnResult turn_result)
         ]

turn_result_to_animations_foldl : (
      Struct.TurnResult.Type ->
      (List Animation) ->
      (List Animation)
   )
turn_result_to_animations_foldl turn_result current_animations =
   (List.append current_animations (turn_result_to_animations turn_result))

maybe_go_to_next_animation : Type -> (Maybe Type)
maybe_go_to_next_animation tra =
   case
   (
      (List.head tra.remaining_animations),
      (List.tail tra.remaining_animations)
   )
   of
      ((Just head), (Just tail)) ->
         (Just
            {tra |
               remaining_animations = tail,
               current_animation = head
            }
         )

      (_, _) -> Nothing

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
maybe_new : (List Struct.TurnResult.Type) -> Bool -> (Maybe Type)
maybe_new turn_results wait_focus =
   case (List.head turn_results) of
      (Just head) ->
         (Just
            {
               remaining_animations =
                  (List.foldl
                     (turn_result_to_animations_foldl)
                     []
                     turn_results
                  ),
               current_animation = Inactive,
               wait_focus = wait_focus
            }
         )

      _ -> Nothing

maybe_trigger_next_step : Type -> (Maybe Type)
maybe_trigger_next_step tra =
   case tra.current_animation of
      (TurnResult action) ->
         (
            case (Struct.TurnResult.maybe_remove_step action) of
               (Just updated_action) ->
                  (Just {tra | current_animation = (TurnResult updated_action)})

               Nothing -> (maybe_go_to_next_animation tra)
         )

      _ -> (maybe_go_to_next_animation tra)

get_current_animation : Type -> Animation
get_current_animation tra = tra.current_animation

waits_for_focus : Type -> Bool
waits_for_focus tra = tra.wait_focus
