module Struct.Weapon exposing
   (
      Type,
      Ref,
      new,
      get_id,
      get_name,
      get_attack_range,
      get_defense_range,
      get_omnimods,
      get_damage_sum,
      decoder,
      default,
      none
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Map -------------------------------------------------------------------
import Struct.Omnimods

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias PartiallyDecoded =
   {
      id : String,
      nam : String,
      rmi : Int,
      rma : Int,
      omni : String
   }

type alias Type =
   {
      id : String,
      name : String,
      def_range : Int,
      atk_range : Int,
      omnimods : Struct.Omnimods.Type,
      damage_sum : Int
   }

type alias Ref = String

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : String -> String -> Int -> Int -> Struct.Omnimods.Type -> Type
new id name range_min range_max omnimods =
   {
      id = id,
      name = name,
      def_range = range_min,
      atk_range = range_max,
      omnimods = omnimods,
      damage_sum = (Struct.Omnimods.get_damage_sum omnimods)
   }

get_id : Type -> String
get_id wp = wp.id

get_name : Type -> String
get_name wp = wp.name

get_attack_range : Type -> Int
get_attack_range wp = wp.atk_range

get_defense_range : Type -> Int
get_defense_range wp = wp.def_range

get_omnimods : Type -> Struct.Omnimods.Type
get_omnimods wp = wp.omnimods

get_damage_sum : Type -> Int
get_damage_sum wp = wp.damage_sum

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map
      (\e -> {e | damage_sum = (Struct.Omnimods.get_damage_sum e.omnimods)})
      (Json.Decode.succeed
         Type
         |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "rmi" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "rma" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "omni" Struct.Omnimods.decoder)
         |> (Json.Decode.Pipeline.hardcoded 0)
      )
   )

none : Type
none = (new "0" "None" 0 0 (Struct.Omnimods.none))

default : Type
default = (none)
