module Struct.Tile exposing
   (
      Ref,
      VariantID,
      FamilyID,
      Type,
      new,
      get_id,
      get_name,
      get_cost,
      get_family,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Constants.UI
import Constants.Movement

import Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Ref = String
type alias VariantID = String
type alias FamilyID = String

type alias Type =
   {
      id : Ref,
      name : String,
      crossing_cost : Int,
      family : FamilyID,
      depth : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Ref -> String -> Int -> FamilyID -> Int -> Type
new id name crossing_cost family depth =
   {
      id = id,
      name = name,
      crossing_cost = crossing_cost,
      family = family,
      depth = depth
   }

get_id : Type -> Ref
get_id tile = tile.id

get_cost : Type -> Int
get_cost tile = tile.crossing_cost

get_name : Type -> String
get_name tile = tile.name

get_family : Type -> FamilyID
get_family tile = tile.family

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ct" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "fa" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "de" Json.Decode.int)
   )
