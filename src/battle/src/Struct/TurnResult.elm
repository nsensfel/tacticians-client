module Struct.TurnResult exposing
   (
      Type(..),
      Attack,
      Movement,
      WeaponSwitch,
      PlayerVictory,
      PlayerDefeat,
      PlayerTurnStart,
      get_next_movement_dir,
      get_actor_index,
      get_attack_defender_index,
      maybe_get_attack_next_step,
      apply_inverse_step,
      apply_step,
      maybe_remove_step,
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
apply_movement_step : (
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type) ->
      Movement ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_movement_step tile_omnimods movement characters players =
   (
      (Util.Array.update_unsafe
         movement.character_index
         (\char ->
            case (List.head movement.path) of
               (Just dir) ->
                  (Struct.Character.dirty_set_location
                     (BattleMap.Struct.Location.neighbor
                        dir
                        (Struct.Character.get_location char)
                     )
                     char
                  )

               Nothing ->
                  (Struct.Character.set_location
                     (tile_omnimods (Struct.Character.get_location char))
                     char
                  )
         )
         characters
      ),
      players
   )

apply_inverse_movement_step : (
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type) ->
      Movement ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_inverse_movement_step tile_omnimods movement characters players =
   (
      (Util.Array.update_unsafe
         movement.character_index
         (\char ->
            (Struct.Character.refresh_omnimods
               (tile_omnimods)
               (Struct.Character.set_location
                  (List.foldr
                     (BattleMap.Struct.Location.neighbor)
                     (movement.destination)
                     (List.map (BattleMap.Struct.Direction.opposite_of) movement.path)
                  )
                  char
               )
            )
         )
         characters
      ),
      players
   )

apply_switched_weapon : (
      WeaponSwitch ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_switched_weapon weapon_switch characters players =
   (
      (Util.Array.update_unsafe
         weapon_switch.character_index
         (\char ->
            (Struct.Character.set_base_character
               (BattleCharacters.Struct.Character.switch_weapons
                 (Struct.Character.get_base_character char)
               )
            )
         )
         characters
      ),
      players
   )

apply_player_defeat : (
      PlayerDefeat ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_player_defeat pdefeat characters players =
   (
      (Array.map
         (\c ->
            (
               if ((Struct.Character.get_player_ix c) == pdefeat.player_index)
               then (Struct.Character.set_defeated True c)
               else c
            )
         )
         characters
      ),
      players
   )

apply_inverse_player_defeat : (
      PlayerDefeat ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_inverse_player_defeat pdefeat characters players =
   (
      (Array.map
         (\c ->
            (
               if ((Struct.Character.get_player_ix c) == pdefeat.player_index)
               then (Struct.Character.set_defeated False c)
               else c
            )
         )
         characters
      ),
      players
   )

apply_attack_step : (
      Attack ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_attack_step attack characters players =
   case (List.head attack.sequence) of
      (Just attack_step) ->
         (
            (Struct.Attack.apply_to_characters
               attack.attacker_index
               attack.defender_index
               attack_step
               characters
            ),
            players
         )

      Nothing ->
         (
            characters,
            (Util.Array.update_unsafe
               attack.attacker_index
               (Struct.Player.set_luck attack.attacker_luck)
               (Util.Array.update_unsafe
                  attack.defender_index
                  (Struct.Player.set_luck attack.defender_luck)
                  players
               )
            )
         )

apply_inverse_attack : (
      Attack ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_inverse_attack attack characters players =
   (
      (List.foldr
         (Struct.Attack.apply_inverse_to_characters
            attack.attacker_index
            attack.defender_index
         )
         characters
         attack.sequence
      ),
      players
   )

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

maybe_remove_movement_step : Movement -> (Maybe Type)
maybe_remove_movement_step movement =
   case (List.tail movement.path) of
      Nothing -> Nothing
      (Just path_tail) ->
         (Just
            (Moved
               {movement |
                  path = path_tail
               }
            )
         )

maybe_remove_attack_step : Attack -> (Maybe Type)
maybe_remove_attack_step attack =
   case (List.tail attack.sequence) of
      Nothing -> Nothing
      (Just sequence_tail) ->
         (Just
            (Attacked
               {attack |
                  sequence = sequence_tail
               }
            )
         )

apply_player_victory : (
      PlayerVictory ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_player_victory player_victory characters players =
   (
      characters,
      players
   )

apply_player_turn_started : (
      PlayerTurnStart ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_player_turn_started player_defeat characters players =
   (
      characters,
      players
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_step : (
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type) ->
      Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_step tile_omnimods turn_result characters players =
   case turn_result of
      (Moved movement) ->
         (apply_movement_step (tile_omnimods) movement characters players)

      (SwitchedWeapon weapon_switch) ->
         (apply_switched_weapon weapon_switch characters players)

      (Attacked attack) ->
         (apply_attack_step attack characters players)

      (PlayerWon pvict) ->
         (apply_player_victory pvict characters players)

      (PlayerLost pdefeat) ->
         (apply_player_defeat pdefeat characters players)

      (PlayerTurnStarted pturns) ->
         (apply_player_turn_started pturns characters players)

apply_inverse_step : (
      (BattleMap.Struct.Location.Type -> Battle.Struct.Omnimods.Type) ->
      Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Player.Type) ->
      (
         (Array.Array Struct.Character.Type),
         (Array.Array Struct.Player.Type)
      )
   )
apply_inverse_step tile_omnimods turn_result characters players =
   case turn_result of
      (Moved movement) ->
         (apply_inverse_movement_step
            (tile_omnimods)
            movement
            characters
            players
         )

      (SwitchedWeapon weapon_switch) ->
         (apply_switched_weapon weapon_switch characters players)

      (Attacked attack) ->
         (apply_inverse_attack attack characters players)

      (PlayerWon pvict) -> (characters, players)

      (PlayerLost pdefeat) ->
         (apply_inverse_player_defeat pdefeat characters players)

      (PlayerTurnStarted pturns) -> (characters, players)

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.field "t" Json.Decode.string)
   |> (Json.Decode.andThen internal_decoder)

maybe_remove_step : Type -> (Maybe Type)
maybe_remove_step turn_result =
   case turn_result of
      (Moved movement) -> (maybe_remove_movement_step movement)
      (SwitchedWeapon _) -> Nothing
      (Attacked attack) -> (maybe_remove_attack_step attack)
      (PlayerWon pvict) -> Nothing
      (PlayerLost pdefeat) -> Nothing
      (PlayerTurnStarted pturns) -> Nothing

get_next_movement_dir : Movement -> BattleMap.Struct.Direction.Type
get_next_movement_dir movement =
   case (List.head movement.path) of
      (Just dir) -> dir
      Nothing -> BattleMap.Struct.Direction.None

get_attack_defender_index : Attack -> Int
get_attack_defender_index attack = attack.defender_index

maybe_get_attack_next_step : Attack -> (Maybe Struct.Attack.Type)
maybe_get_attack_next_step attack = (List.head attack.sequence)

get_actor_index : Type -> Int
get_actor_index turn_result =
   case turn_result of
      (Moved movement) -> movement.character_index
      (SwitchedWeapon weapon_switch) -> weapon_switch.character_index
      (Attacked attack) -> attack.attacker_index
      (PlayerWon pvict) -> pvict.player_index
      (PlayerLost pdefeat) -> pdefeat.player_index
      (PlayerTurnStarted pturns) -> pturns.player_index
