module Struct.PuppeteerAction exposing
   (
      Type(..),
      Group(..),
      from_turn_result
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
   | RefreshCharacter (Boolean, Int)
   | RefreshCharactersOf (Boolean, Int)
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
         (Perform
            [
               (RefreshCharacter (False, attacker_ix)),
               (RefreshCharacter (False, defender_ix))
            ]
         ),
         (PerformFor (2.0, [(Focus attacker_ix)])),
         (PerformFor (2.0, [(Focus defender_ix)])),
         (List.map
            (PerformFor (..., (Hit attack)))
         ),
         (Perform
            [
               (RefreshCharacter (True, attacker_ix)),
               (RefreshCharacter (True, defender_ix))
            ]
         )
      ]

from_moved : Struct.TurnResult.Movement -> (List Type)
from_moved movement =
   let actor_ix = (Struct.TurnResult.get_movement_actor movement) in
      (
         [
            (PerformFor (1.0, [(Focus actor_ix)])),
            (Perform [(RefreshCharacter (False, actor_ix))]),
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
         [ (Perform [(RefreshCharacter (True, actor_ix))]) ]
      )

from_switched_weapon : Struct.TurnResult.WeaponSwitch -> (List Type)
from_switched_weapon weapon_switch =
   let actor_ix = (Struct.TurnResult.get_weapon_switch_actor weapon_switch) in
      [
         (PerformFor (1.0, [(Focus actor_ix)])),
         (PerformFor
            (
               2.0,
               [
                  (RefreshCharacter (False, actor_ix)),
                  (SwapWeapons actor_ix)
                  (RefreshCharacter (True, actor_ix))
               ]
            )
         )
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
               (RefreshCharactersOf (False, player_ix)),
               (AnnounceLoss
                  (Struct.TurnResult.get_player_loss_index player_loss)
               ),
               (RefreshCharactersOf (True, player_ix))
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
               (RefreshCharactersOf (False, player_ix)),
               (StartPlayerTurn
                  (Struct.TurnResult.get_player_start_of_turn_index
                     player_turn_started
                  )
               ),
               (RefreshCharactersOf (True, player_ix))
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
