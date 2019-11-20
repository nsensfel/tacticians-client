module Struct.TurnResultAnimator exposing
   (
      Type,
      Animation(..),
      maybe_new,
      maybe_trigger_next_step,
      waits_for_focus,
      get_current_animation,
      get_animated_character_indices
   )

-- Elm -------------------------------------------------------------------------
import Set

-- Local Module ----------------------------------------------------------------
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
      animated_character_ixs : (Set.Set Int),
      remaining_animations : (List Animation),
      current_animation : Animation,
      wait_focus : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
turn_result_to_animations : (
      Struct.TurnResult.Type ->
      ((List Animation), (Set.Set Int))
   )
turn_result_to_animations turn_result =
   case turn_result of
      (Struct.TurnResult.Attacked attack) ->
         let
            attacker_ix = (Struct.TurnResult.get_actor_index turn_result)
            defender_ix = (Struct.TurnResult.get_attack_defender_index attack)
         in
            (
               [
                  (Focus attacker_ix),
                  (Focus defender_ix),
                  (AttackSetup (attacker_ix, defender_ix)),
                  (TurnResult turn_result)
               ],
               (Set.fromList [defender_ix, attacker_ix])
            )

      _ ->
         let actor_ix = (Struct.TurnResult.get_actor_index turn_result) in
            (
               [
                  (Focus actor_ix),
                  (TurnResult turn_result)
               ],
               (Set.singleton actor_ix)
            )

turn_result_to_animations_foldl : (
      Struct.TurnResult.Type ->
      ((List Animation), (Set.Set Int)) ->
      ((List Animation), (Set.Set Int))
   )
turn_result_to_animations_foldl turn_result (animations, char_ixs) =
   let
      (new_animations, new_char_ixs) = (turn_result_to_animations turn_result)
   in
      (
         (List.append animations new_animations),
         (Set.union new_char_ixs char_ixs)
      )

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

initialize_animator : Type -> Type
initialize_animator model =
   let
      timeline_list = (Array.toList model.timeline)
      (characters, players) =
         (List.foldr
            (\event (pcharacters, pplayers) ->
               (Struct.TurnResult.apply_inverse_step
                  (tile_omnimods_fun model)
                  event
                  pcharacters
                  pplayers
               )
            )
            (model.characters, model.players)
            timeline_list
         )
   in
      {model |
         animator =
            (Struct.TurnResultAnimator.maybe_new
               (List.reverse timeline_list)
               True
            ),
         ui = (Struct.UI.default),
         characters = characters,
         players = players
      }

move_animator_to_next_step : Type -> Type
move_animator_to_next_step model =
   case model.animator of
      Nothing -> model
      (Just animator) ->
         case (Struct.TurnResultAnimator.maybe_trigger_next_step animator) of
            Nothing ->
               (Set.foldl
                  (regenerate_attack_of_opportunity_markers)
                  {model | animator = Nothing }
                  (Struct.TurnResultAnimator.get_animated_character_indices
                     animator
                  )
               )

            just_next_animator -> {model | animator = just_next_animator }

apply_animator_step : Type -> Type
apply_animator_step model =
   case model.animator of
      Nothing -> model
      (Just animator) ->
         case (Struct.TurnResultAnimator.get_current_animation animator) of
            (Struct.TurnResultAnimator.TurnResult turn_result) ->
               let
                  (characters, players) =
                     (Struct.TurnResult.apply_step
                        (tile_omnimods_fun model)
                        turn_result
                        model.characters
                        model.players
                     )
               in
                  {model |
                     characters = characters,
                     players = players
                  }
            _ -> model

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
maybe_new : (List Struct.TurnResult.Type) -> Bool -> (Maybe Type)
maybe_new turn_results wait_focus =
   case (List.head turn_results) of
      (Just head) ->
         (
            let
               (animations, character_ixs) =
                  (List.foldl
                     (turn_result_to_animations_foldl)
                     ([], (Set.empty))
                     turn_results
                  )
            in
               (Just
                  {
                     remaining_animations = animations,
                     current_animation = Inactive,
                     wait_focus = wait_focus,
                     animated_character_ixs = character_ixs
                  }
               )
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

get_animated_character_indices : Type -> (Set.Set Int)
get_animated_character_indices tra = tra.animated_character_ixs
