module Struct.Attack exposing
   (
      Type,
      Order(..),
      Precision(..),
      apply_to_characters,
      apply_inverse_to_characters,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Struct.Character

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Order =
   First
   | Counter
   | Second

type Precision =
   Hit
   | Graze
   | Miss

type alias Type =
   {
      order : Order,
      precision : Precision,
      critical : Bool,
      parried : Bool,
      damage : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
order_from_string : String -> Order
order_from_string str =
   case str of
      "f" -> First
      "s" -> Second
      _ -> Counter

precision_from_string : String -> Precision
precision_from_string str =
   case str of
      "h" -> Hit
      "g" -> Graze
      _ -> Miss

order_decoder : (Json.Decode.Decoder Order)
order_decoder = (Json.Decode.map (order_from_string) (Json.Decode.string))

precision_decoder : (Json.Decode.Decoder Precision)
precision_decoder =
   (Json.Decode.map (precision_from_string) (Json.Decode.string))

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map5
      Type
      (Json.Decode.field "ord" (order_decoder))
      (Json.Decode.field "pre" (precision_decoder))
      (Json.Decode.field "cri" (Json.Decode.bool))
      (Json.Decode.field "par" (Json.Decode.bool))
      (Json.Decode.field "dmg" (Json.Decode.int))
   )

apply_damage_to_character : (
      Int ->
      Struct.Character.Type ->
      Struct.Character.Type
   )
apply_damage_to_character damage char =
   (Struct.Character.set_current_health
      ((Struct.Character.get_current_health char) - damage)
      char
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to_characters : (
      Int ->
      Int ->
      Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_to_characters attacker_ix defender_ix attack characters =
   if ((attack.order == Counter) == attack.parried)
   then
      case (Array.get defender_ix characters) of
         (Just char) ->
            (Array.set
               defender_ix
               (apply_damage_to_character attack.damage char)
               characters
            )

         Nothing -> characters
   else
      case (Array.get attacker_ix characters) of
         (Just char) ->
            (Array.set
               attacker_ix
               (apply_damage_to_character attack.damage char)
               characters
            )

         Nothing -> characters

apply_inverse_to_characters : (
      Int ->
      Int ->
      Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_inverse_to_characters attacker_ix defender_ix attack characters =
   if ((attack.order == Counter) == attack.parried)
   then
      case (Array.get defender_ix characters) of
         (Just char) ->
            (Array.set
               defender_ix
               (apply_damage_to_character (-1 * attack.damage) char)
               characters
            )

         Nothing -> characters
   else
      case (Array.get attacker_ix characters) of
         (Just char) ->
            (Array.set
               attacker_ix
               (apply_damage_to_character (-1 * attack.damage) char)
               characters
            )

         Nothing -> characters
