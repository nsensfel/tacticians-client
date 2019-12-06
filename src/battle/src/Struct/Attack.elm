module Struct.Attack exposing
   (
      Type,
      Order(..),
      Precision(..),
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode

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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
