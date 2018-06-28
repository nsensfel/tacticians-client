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
      apply_to_characters,
      apply_inverse_to_characters,
      apply_step_to_characters,
      maybe_remove_step,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Struct.Attack
import Struct.Character
import Struct.Direction
import Struct.Location
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Movement =
   {
      character_index : Int,
      path : (List Struct.Direction.Type),
      destination : Struct.Location.Type
   }

type alias Attack =
   {
      attacker_index : Int,
      defender_index : Int,
      sequence : (List Struct.Attack.Type)
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
apply_movement_to_character : (
      Movement ->
      Struct.Character.Type ->
      Struct.Character.Type
   )
apply_movement_to_character movement char =
   (Struct.Character.set_location movement.destination char)

apply_movement_step_to_character : (
      Movement ->
      Struct.Character.Type ->
      Struct.Character.Type
   )
apply_movement_step_to_character movement char =
   case (List.head movement.path) of
      (Just dir) ->
         (Struct.Character.set_location
            (Struct.Location.neighbor dir (Struct.Character.get_location char))
            char
         )

      Nothing -> char

apply_inverse_movement_to_character : (
      Movement ->
      Struct.Character.Type ->
      Struct.Character.Type
   )
apply_inverse_movement_to_character movement char =
   (Struct.Character.set_location
      (List.foldr
         (Struct.Location.neighbor)
         (movement.destination)
         (List.map (Struct.Direction.opposite_of) movement.path)
      )
      char
   )

apply_weapon_switch_to_character : (
      Struct.Character.Type ->
      Struct.Character.Type
   )
apply_weapon_switch_to_character char =
   (Struct.Character.set_weapons
      (Struct.WeaponSet.switch_weapons
         (Struct.Character.get_weapons char)
      )
      char
   )

apply_attack_to_characters : (
      Attack ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_attack_to_characters attack characters =
   (List.foldl
      (Struct.Attack.apply_to_characters
         attack.attacker_index
         attack.defender_index
      )
      characters
      attack.sequence
   )

apply_attack_step_to_characters : (
      Attack ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_attack_step_to_characters attack characters =
   case (List.head attack.sequence) of
      (Just attack_step) ->
         (Struct.Attack.apply_to_characters
            attack.attacker_index
            attack.defender_index
            attack_step
            characters
         )

      Nothing -> characters

apply_inverse_attack_to_characters : (
      Attack ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_inverse_attack_to_characters attack characters =
   (List.foldr
      (Struct.Attack.apply_inverse_to_characters
         attack.attacker_index
         attack.defender_index
      )
      characters
      attack.sequence
   )

movement_decoder : (Json.Decode.Decoder Movement)
movement_decoder =
   (Json.Decode.map3
      Movement
      (Json.Decode.field "ix" Json.Decode.int)
      (Json.Decode.field
         "p"
         (Json.Decode.list (Struct.Direction.decoder))
      )
      (Json.Decode.field
         "nlc"
         (Struct.Location.decoder)
      )
   )

attack_decoder : (Json.Decode.Decoder Attack)
attack_decoder =
   (Json.Decode.map3
      Attack
      (Json.Decode.field "aix" Json.Decode.int)
      (Json.Decode.field "dix" Json.Decode.int)
      (Json.Decode.field
         "seq"
         (Json.Decode.list (Struct.Attack.decoder))
      )
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to_characters : (
      Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_to_characters turn_result characters =
   case turn_result of
      (Moved movement) ->
         case (Array.get movement.character_index characters) of
            (Just char) ->
               (Array.set
                  movement.character_index
                  (apply_movement_to_character movement char)
                  characters
               )

            Nothing ->
               characters

      (SwitchedWeapon weapon_switch) ->
         case (Array.get weapon_switch.character_index characters) of
            (Just char) ->
               (Array.set
                  weapon_switch.character_index
                  (apply_weapon_switch_to_character char)
                  characters
               )

            Nothing ->
               characters

      (Attacked attack) ->
         (apply_attack_to_characters attack characters)

      (PlayerWon pvict) -> characters

      (PlayerLost pdefeat) ->
         -- TODO: Their characters are supposed to disappear.
         characters

      (PlayerTurnStarted pturns) -> characters

apply_step_to_characters : (
      Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_step_to_characters turn_result characters =
   case turn_result of
      (Moved movement) ->
         case (Array.get movement.character_index characters) of
            (Just char) ->
               (Array.set
                  movement.character_index
                  (apply_movement_step_to_character movement char)
                  characters
               )

            Nothing ->
               characters

      (SwitchedWeapon weapon_switch) ->
         case (Array.get weapon_switch.character_index characters) of
            (Just char) ->
               (Array.set
                  weapon_switch.character_index
                  (apply_weapon_switch_to_character char)
                  characters
               )

            Nothing ->
               characters

      (Attacked attack) ->
         (apply_attack_step_to_characters attack characters)

      (PlayerWon pvict) -> characters

      (PlayerLost pdefeat) -> characters

      (PlayerTurnStarted pturns) -> characters

apply_inverse_to_characters : (
      Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_inverse_to_characters turn_result characters =
   case turn_result of
      (Moved movement) ->
         case (Array.get movement.character_index characters) of
            (Just char) ->
               (Array.set
                  movement.character_index
                  (apply_inverse_movement_to_character movement char)
                  characters
               )

            Nothing ->
               characters

      (SwitchedWeapon weapon_switch) ->
         case (Array.get weapon_switch.character_index characters) of
            (Just char) ->
               (Array.set
                  weapon_switch.character_index
                  (apply_weapon_switch_to_character char)
                  characters
               )

            Nothing ->
               characters

      (Attacked attack) ->
         (apply_inverse_attack_to_characters attack characters)

      (PlayerWon pvict) -> characters

      (PlayerLost pdefeat) ->
         -- TODO
         -- Their characters are supposed to have disappeared, so we have to
         -- make them visible again.
         characters

      (PlayerTurnStarted pturns) -> characters

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

get_next_movement_dir : Movement -> Struct.Direction.Type
get_next_movement_dir movement =
   case (List.head movement.path) of
      (Just dir) -> dir
      Nothing -> Struct.Direction.None

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
