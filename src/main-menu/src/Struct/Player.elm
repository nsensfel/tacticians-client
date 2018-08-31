module Struct.Player exposing
   (
      Type,
      get_username,
      get_maps,
      get_campaigns,
      get_invasions,
      get_events,
      get_roster_id,
      get_inventory_id,
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
      omnimods : Struct.Omnimods.Type,
      damage_sum : Int
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
      omnimods = omnimods,
      damage_sum = (Struct.Omnimods.get_damage_sum omnimods)
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

get_damage_sum : Type -> Int
get_damage_sum wp = wp.damage_sum

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map
      (\e -> {e | damage_sum = (Struct.Omnimods.get_damage_sum e.omnimods)})
      (Json.Decode.Pipeline.decode
         Type
         |> (Json.Decode.Pipeline.required "usr" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "maps" Json.Decode.list)
         |> (Json.Decode.Pipeline.required "cmps" Json.Decode.list)
         |> (Json.Decode.Pipeline.required "invs" Json.Decode.list)
         |> (Json.Decode.Pipeline.required "evts" Json.Decode.list)
         |> (Json.Decode.Pipeline.required "rtid" Json.Decode.list)
         |> (Json.Decode.Pipeline.required "ivid" Json.Decode.list)
      )
   )

none : Type
none = (new 0 "None" 0 0 (Struct.Omnimods.new [] [] [] []))
