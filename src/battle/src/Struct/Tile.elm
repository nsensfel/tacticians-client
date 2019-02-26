module Struct.Tile exposing
   (
      Ref,
      VariantID,
      Type,
      new,
      get_id,
      get_name,
      get_cost,
      get_omnimods,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------
import Constants.UI
import Constants.Movement

import Struct.Location
import Struct.Omnimods

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Ref = String
type alias VariantID = String

type alias Type =
   {
      id : Ref,
      name : String,
      crossing_cost : Int,
      omnimods : Struct.Omnimods.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Ref -> String -> Int -> Struct.Omnimods.Type -> Type
new id name crossing_cost omnimods =
   {
      id = id,
      name = name,
      crossing_cost = crossing_cost,
      omnimods = omnimods
   }

get_id : Type -> Ref
get_id tile = tile.id

get_cost : Type -> Int
get_cost tile = tile.crossing_cost

get_name : Type -> String
get_name tile = tile.name

get_omnimods : Type -> Struct.Omnimods.Type
get_omnimods t = t.omnimods

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ct" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "omni" Struct.Omnimods.decoder)
   )
