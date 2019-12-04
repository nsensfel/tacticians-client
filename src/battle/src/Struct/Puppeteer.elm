module Struct.Puppeteer exposing
   (
      Type,
      new,
      append,
      is_active,
      requires_priming,
   )

-- Elm -------------------------------------------------------------------------
import Array
import Set

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.TurnResult
import Struct.PuppeteerAction

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      actions : (List Struct.PuppeteerAction.Type),
      primed : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
turn_result_to_actions : Struct.TurnResult.Type -> (List Action)
turn_result_to_actions turn_result =
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
               (TurnResult turn_result),
               (RefreshCharacter attacker_ix),
               (RefreshCharacter defender_ix)
            ]

      _ ->
         let actor_ix = (Struct.TurnResult.get_actor_index turn_result) in
            [
               (Focus actor_ix),
               (TurnResult turn_result),
               (RefreshCharacter actor_ix)
            ]

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

move_animator_to_next_step : (Maybe Type) -> (Maybe Type)
move_animator_to_next_step maybe_animator =
   case maybe_animator of
      Nothing -> maybe_animator
      (Just animator) ->
         (Struct.TurnResultAnimator.maybe_trigger_next_step animator)

--         case (Struct.TurnResultAnimator.maybe_trigger_next_step animator) of
--            Nothing ->
--               (Set.foldl
--                  (regenerate_attack_of_opportunity_markers)
--                  {model | animator = Nothing }
--                  (Struct.TurnResultAnimator.get_animated_character_indices
--                     animator
--                  )
--               )
--
--            just_next_animator -> {model | animator = just_next_animator }

apply_animator_step : (
      BattleMap.Struct.DataSet.Type ->
      Type ->
      Struct.Battle.Type ->
      Struct.Battle.Type
   )
apply_animator_step dataset animator battle =
   case (Struct.TurnResultAnimator.get_current_animation animator) of
      (Struct.TurnResultAnimator.TurnResult turn_result) ->
         let
            (characters, players) =
               (Struct.TurnResult.apply_step
                  (Struct.Battle.get_tile_omnimods_fun dataset battle)
                  turn_result
                  battle
               )
         in
            (Struct.Battle.set_players
               players
               (Struct.Battle.set_characters characters battle)
            )

      _ -> battle

pop : Type -> (Type, (Maybe Action))
pop puppeteer =
   case (Util.List.pop puppeteer.remaining_animations) of
      Nothing -> (puppeteer, Nothing)
      (Just (action, remaining_animations)) ->
         (
            {puppeteer |
               remaining_animations = remaining_animations,
               primed =
                  if (List.isEmpty remaining_animations)
                  then False
                  else puppeteer.primed
            },
            action
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Type
new =
   {
      remaining_animations = [],
      primed = False
   }

append : (List Struct.TurnResult.Type) -> Type -> Type
append turn_results puppeteer =
   {puppeteer |
      remaining_animations =
         (List.concat
            puppeteer.remaining_animations
            (List.map (turn_result_to_actions) turn_results)
         )
   }

is_active : Type -> Bool
is_active puppeteer = (not (List.isEmpty puppeteer.remaining_animations))

requires_priming : Type -> Bool
requires_priming puppeteer = (is_active and (not puppeteer.is_primed))

forward : Struct.Battle.Type -> Type -> (Struct.Battle.Type, Type)
forward battle puppeteer =
   case (pop puppeteer) of
      (next_puppeteer, Nothing) -> (battle, next_puppeteer)
      (next_puppeteer, (Just action)) ->
         ((apply_action action battle), next_puppeteer)

forward : Struct.Battle.Type -> Type -> (Struct.Battle.Type, Type)
forward battle puppeteer =
   case (pop puppeteer) of
      (next_puppeteer, Nothing) -> (battle, next_puppeteer)
      (next_puppeteer, (Just action)) ->
         ((apply_action action battle), next_puppeteer)
