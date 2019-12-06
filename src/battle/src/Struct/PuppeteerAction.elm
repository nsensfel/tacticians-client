module Struct.PuppeteerAction exposing
   (
      Type(..),
      Group(..),
      from_turn_result,
      forward,
      backward
   )

-- Elm -------------------------------------------------------------------------
import Array
import Set

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.TurnResult

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Effect =
   AnnounceLoss Int
   | AnnounceVictory Int
   | Focus Int
   | Hit Struct.Attack.Type
   | Move (Int, Battle.Struct.Direction)
   | RefreshCharacter Int
   | StartTurn Int
   | SwapWeapons Int
   | Target (Int, Int)

type Type =
   Perform (List Effect)
   | PerformFor (Float, (List Effect))

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
from_attacked : Struct.Attack.Type -> (List Type)
from_attacked attack =
   let
      attacker_ix = (Struct.TurnResult.get_actor_index turn_result)
      defender_ix = (Struct.TurnResult.get_attack_defender_index attack)
   in
      [
         (PerformFor (2.0, [(Focus attacker_ix)])),
         (PerformFor (2.0, [(Focus defender_ix)])),
         (List.map
            (PerformFor (..., (Hit attack)))
         ),
         (Perform
            [
               (RefreshCharacter attacker_ix),
               (RefreshCharacter defender_ix)
            ]
         )
      ]

from_moved : Struct.TurnResult.Movement -> (List Type)
from_moved movement =
   let actor_ix = (Struct.TurnResult.get_movement_actor movement) in
      (
         [
            (PerformFor (1.0, [(Focus actor_ix)])),
            |
            (List.map
               (\dir ->
                  (PerformFor
                     (
                        0.5,
                        [(Move (actor_ix, dir))]
                     )
                  )
               )
            )
         ]
         ++
         [ (Perform [(RefreshCharacter actor_ix)]) ]
      )

from_switched_weapon : Struct.TurnResult.WeaponSwitch -> (List Type)
from_switched_weapon weapon_switch =
   let actor_ix = (Struct.TurnResult.get_weapon_switch_actor weapon_switch) in
      [
         (PerformFor (1.0, [(Focus actor_ix)])),
         (PerformFor (2.0, [(SwapWeapons actor_ix)]))
      ]

from_player_won : Struct.TurnResult.PlayerVictory -> (List Type)
from_player_won player_victory =
   [
      (PerformFor
         (
            2.0,
            [
               (AnnounceVictory
                  (Struct.TurnResult.get_player_victory_index player_victory)
               )
            ]
         )
      )
   ]

from_player_lost : Struct.TurnResult.PlayerLoss -> (List Type)
from_player_lost player_loss =
   [
      (PerformFor
         (
            2.0,
            [
               (AnnounceLoss
                  (Struct.TurnResult.get_player_loss_index player_loss)
               )
            ]
         )
      )
   ]

from_player_turn_started : Struct.TurnResult.PlayerTurnStart -> (List Type)
from_player_turn_started player_turn_started =
   [
      (PerformFor
         (
            2.0,
            [
               (StartPlayerTurn
                  (Struct.TurnResult.get_player_start_of_turn_index
                     player_turn_started
                  )
               )
            ]
         )
      )
   ]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
from_turn_results : Struct.TurnResult.Type -> (List Type)
from_turn_results turn_result =
   case turn_result of
      (Struct.TurnResult.Moved movement) -> (from_moved movement)
      (Struct.TurnResult.Attacked attack) -> (from_attacked attack)
      (Struct.TurnResult.SwitchedWeapon weapon_switch) ->
         (from_switched_weapon movement)

      (Struct.TurnResult.PlayerWon player_victory) ->
         (from_player_won player_victory)

      (Struct.TurnResult.PlayerLost player_loss) ->
         (from_player_lost player_loss)

      (Struct.TurnResult.PlayerTurnStarted player_turn_start) ->
         (from_player_turn_started player_turn_start)

forward : Type -> Struct.Battle.Type -> Struct.Battle.Type
forward puppeteer_action battle =
   case puppeteer_action of
      Inactive -> battle
      (Target (actor_ix, target_ix)) ->
         (forward_target actor_ix target_ix battle)
      (Hit attack) -> (forward_hit attack battle)
      (Focus actor_ix) -> (forward_focus actor_ix battle)
      (Move (actor_ix, direction)) -> (forward_move actor_ix direction battle)
      (SwapWeapons actor_ix) -> (forward_swap_weapons actor_ix battle)
      (RefreshCharacter actor_ix) -> (forward_refresh_character actor_ix battle)
      (Sequence list) -> (List.foldl (forward) battle list)

backward : Type -> Struct.Battle.Type -> Struct.Battle.Type
backward puppeteer_action battle =
   case puppeteer_action of
      (Hit attack) -> (backward_hit attack battle)
      (Move (actor_ix, direction)) -> (backward_move actor_ix direction battle)
      (SwapWeapons actor_ix) -> (backward_swap_weapons actor_ix battle)
      (Sequence list) -> (List.foldr (backward) battle list)
      _ -> battle
