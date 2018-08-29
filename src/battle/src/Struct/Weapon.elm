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
      decoder,
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
      id : Int,
      nam : String,
      rmi : Int,
      rma : Int,
      omni : String
   }

type alias Type =
   {
      id : Int,
      name : String,
      def_range : Int,
      atk_range : Int,
      omnimods : Struct.Omnimods.Type
   }

type alias Ref = Int

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> String -> Int -> Int -> Struct.Omnimods.Type -> Type
new id name range_min range_max omnimods =
   {
      id = id,
      name = name,
      def_range = range_min,
      atk_range = range_max,
      omnimods = omnimods
   }

get_id : Type -> Int
get_id wp = wp.id

get_name : Type -> String
get_name wp = wp.name

get_attack_range : Type -> Int
get_attack_range wp = wp.atk_range

get_defense_range : Type -> Int
get_defense_range wp = wp.def_range

get_omnimods : Type -> Struct.Omnimods.Type
get_omnimods wp = wp.omnimods

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "rmi" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "rma" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "omni" Struct.Omnimods.decoder)
   )

none : Type
none = (new 0 "None" 0 0 (Struct.Omnimods.new [] [] [] []))
