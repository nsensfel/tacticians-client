module Struct.TurnResult exposing
   (
      Type(..),
      Attack,
      Movement,
      WeaponSwitch,
      PlayerVictory,
      PlayerDefeat,
      PlayerTurnStart,
      get_start_of_turn_player_index,
      get_victory_player_index,
      get_loss_player_index,
      get_weapon_switch_actor_index,
      get_movement_actor_index,
      get_movement_path,
      get_attack_actor_index,
      get_attack_target_index,
      get_attack_sequence,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode

-- Shared ----------------------------------------------------------------------
import Util.Array

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Direction

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
import Struct.Attack
import Struct.Character
import Struct.Player

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Movement =
   {
      character_index : Int,
      path : (List BattleMap.Struct.Direction.Type),
      destination : BattleMap.Struct.Location.Type
   }

type alias Attack =
   {
      attacker_index : Int,
      defender_index : Int,
      sequence : (List Struct.Attack.Type),
      attacker_luck : Int,
      defender_luck : Int
   }

type alias WeaponSwitch =
   {
      character_index : Int
   }

type alias PlayerVictory =
   {
      player_index : Int
   }

type alias PlayerDefeat =
   {
      player_index : Int
   }

type alias PlayerTurnStart =
   {
      player_index : Int
   }

type Type =
   Moved Movement
   | Attacked Attack
   | SwitchedWeapon WeaponSwitch
   | PlayerWon PlayerVictory
   | PlayerLost PlayerDefeat
   | PlayerTurnStarted PlayerTurnStart

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
movement_decoder : (Json.Decode.Decoder Movement)
movement_decoder =
   (Json.Decode.map3
      Movement
      (Json.Decode.field "ix" Json.Decode.int)
      (Json.Decode.field "p" (Json.Decode.list (BattleMap.Struct.Direction.decoder)))
      (Json.Decode.field "nlc" (BattleMap.Struct.Location.decoder))
   )

attack_decoder : (Json.Decode.Decoder Attack)
attack_decoder =
   (Json.Decode.map5
      Attack
      (Json.Decode.field "aix" Json.Decode.int)
      (Json.Decode.field "dix" Json.Decode.int)
      (Json.Decode.field "seq" (Json.Decode.list (Struct.Attack.decoder)))
      (Json.Decode.field "alk" Json.Decode.int)
      (Json.Decode.field "dlk" Json.Decode.int)
   )

weapon_switch_decoder : (Json.Decode.Decoder WeaponSwitch)
weapon_switch_decoder =
   (Json.Decode.map
      WeaponSwitch
      (Json.Decode.field "ix" Json.Decode.int)
   )

player_won_decoder : (Json.Decode.Decoder PlayerVictory)
player_won_decoder =
   (Json.Decode.map
      PlayerVictory
      (Json.Decode.field "ix" Json.Decode.int)
   )

player_lost_decoder : (Json.Decode.Decoder PlayerDefeat)
player_lost_decoder =
   (Json.Decode.map
      PlayerDefeat
      (Json.Decode.field "ix" Json.Decode.int)
   )

player_turn_started_decoder : (Json.Decode.Decoder PlayerTurnStart)
player_turn_started_decoder =
   (Json.Decode.map
      PlayerTurnStart
      (Json.Decode.field "ix" Json.Decode.int)
   )

internal_decoder : String -> (Json.Decode.Decoder Type)
internal_decoder kind =
   case kind of
      "swp" ->
         (Json.Decode.map
            (\x -> (SwitchedWeapon x))
            (weapon_switch_decoder)
         )

      "mv" ->
         (Json.Decode.map
            (\x -> (Moved x))
            (movement_decoder)
         )

      "atk" ->
         (Json.Decode.map
            (\x -> (Attacked x))
            (attack_decoder)
         )

      "pwo" ->
         (Json.Decode.map
            (\x -> (PlayerWon x))
            (player_won_decoder)
         )

      "plo" ->
         (Json.Decode.map
            (\x -> (PlayerLost x))
            (player_lost_decoder)
         )

      "pts" ->
         (Json.Decode.map
            (\x -> (PlayerTurnStarted x))
            (player_turn_started_decoder)
         )

      other ->
         (Json.Decode.fail
            (
               "Unknown kind of turn result: \""
               ++ other
               ++ "\"."
            )
         )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.field "t" Json.Decode.string)
   |> (Json.Decode.andThen internal_decoder)

get_start_of_turn_player_index : PlayerTurnStart -> Int
get_start_of_turn_player_index start_of_turn = start_of_turn.player_index

get_victory_player_index : PlayerVictory -> Int
get_victory_player_index player_victory = player_victory.player_index

get_loss_player_index : PlayerDefeat -> Int
get_loss_player_index player_loss = player_loss.player_index

get_weapon_switch_actor_index : WeaponSwitch -> Int
get_weapon_switch_actor_index weapon_switch = weapon_switch.character_index

get_movement_actor_index : Movement -> Int
get_movement_actor_index movement = movement.character_index

get_movement_path : Movement -> (List BattleMap.Struct.Direction.Type)
get_movement_path movement = movement.path

get_attack_actor_index : Attack -> Int
get_attack_actor_index attack = attack.attacker_index

get_attack_target_index : Attack -> Int
get_attack_target_index attack = attack.defender_index

get_attack_sequence : Attack -> (List Struct.Attack.Type)
get_attack_sequence attack = attack.sequence
