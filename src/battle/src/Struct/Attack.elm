module Struct.Attack exposing
   (
      Type,
      Order(..),
      Precision(..),
      decoder,
      get_actor_index,
      get_damage,
      get_is_a_parry,
      get_is_a_critical,
      get_new_actor_luck,
      get_new_target_luck,
      get_order,
      get_precision,
      get_target_index
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode
import Json.Decode.Pipeline

-- Local Module ----------------------------------------------------------------
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
      attacker_index : Int,
      defender_index : Int,
      order : Order,
      precision : Precision,
      critical : Bool,
      parried : Bool,
      damage : Int,
      attacker_luck : Int,
      defender_luck : Int
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_order : Type -> Order
get_order at = at.order

get_is_a_parry : Type -> Bool
get_is_a_parry at = at.parried

get_is_a_critical : Type -> Bool
get_is_a_critical at = at.critical

get_precision : Type -> Precision
get_precision at = at.precision

get_damage : Type -> Int
get_damage at = at.damage

get_actor_index : Type -> Int
get_actor_index at = at.attacker_index

get_target_index : Type -> Int
get_target_index at = at.defender_index

get_new_actor_luck : Type -> Int
get_new_actor_luck at = at.attacker_luck

get_new_target_luck : Type -> Int
get_new_target_luck at = at.defender_luck

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "aix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "dix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "ord" (order_decoder))
      |> (Json.Decode.Pipeline.required "pre" (precision_decoder))
      |> (Json.Decode.Pipeline.required "cri" (Json.Decode.bool))
      |> (Json.Decode.Pipeline.required "par" (Json.Decode.bool))
      |> (Json.Decode.Pipeline.required "dmg" (Json.Decode.int))
      |> (Json.Decode.Pipeline.required "alk" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "dlk" Json.Decode.int)
   )
