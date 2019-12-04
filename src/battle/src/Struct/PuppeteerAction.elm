module Struct.PuppeteerAction exposing
   (
      Type,
      Action(..),
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
type Type =
   Inactive
   | Target (Int, Int)
   | Hit Struct.Attack.Type
   | Focus Int
   | Move (Int, Battle.Struct.Direction)
   | SwapWeapons Int
   | RefreshCharacter Int
   | Sequence (List Type)

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
         (Focus attacker_ix),
         (Focus defender_ix),
         (Hit attack),
         (Sequence
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
            (Focus actor_ix),
            | (List.map (\dir -> (Move (actor_ix, dir))))
         ]
         ++
         [ (RefreshCharacter actor_ix) ]
      )

from_switched_weapon : Struct.TurnResult.WeaponSwitch -> (List Type)
from_switched_weapon weapon_switch =
   let actor_ix = (Struct.TurnResult.get_weapon_switch_actor weapon_switch) in
      [
         (Focus actor_ix),
         (SwapWeapons actor_ix)
      ]

from_player_won : Struct.TurnResult.PlayerVictory -> (List Type)
from_player_won player_victory = []

from_player_lost : Struct.TurnResult.PlayerLoss -> (List Type)
from_player_lost player_loss = []

from_player_turn_started : Struct.TurnResult.PlayerTurnStart -> (List Type)
from_player_turn_started player_turn_started = []

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
