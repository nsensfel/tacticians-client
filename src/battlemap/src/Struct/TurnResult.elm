module Struct.TurnResult exposing
   (
      Type(..),
      Attack,
      Movement,
      WeaponSwitch,
      apply_to_characters,
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

type Type =
   Moved Movement
   | Attacked Attack
   | SwitchedWeapon WeaponSwitch

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

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.field "t" Json.Decode.string)
   |> (Json.Decode.andThen internal_decoder)
