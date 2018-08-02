module Struct.Tile exposing
   (
      Ref,
      Type,
      Instance,
      new,
      clone_instance,
      new_instance,
      error_tile_instance,
      get_id,
      get_name,
      get_cost,
      get_instance_cost,
      get_location,
      get_icon_id,
      get_type_id,
      get_variant_ix,
      solve_tile_instance,
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
type alias Ref = Int

type alias PartiallyDecoded =
   {
      id : Int,
      nam : String,
      ct : Int
   }

type alias Type =
   {
      id : Int,
      name : String,
      crossing_cost : Int
   }

type alias Instance =
   {
      location : Struct.Location.Type,
      crossing_cost : Int,
      type_id : Int,
      border_id : Int,
      variant_ix : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
noise_function : Int -> Int -> Int -> Int
noise_function a b c =
   let
      af = (toFloat a)
      bf = (toFloat b)
      cf = (toFloat c)
      (df, ef) = (toPolar (af, bf))
      (ff, gf) = (toPolar (bf, af))
      (hf, jf) = (toPolar (bf, cf))
      (kf, lf) = (toPolar (cf, bf))
      (mf, nf) = (toPolar (af, cf))
      (qf, rf) = (toPolar (cf, af))
      (resA, resB) = (fromPolar ((df + qf), (ef + nf)))
      (resC, resD) = (fromPolar ((hf + mf), (jf + gf)))
      (resE, resF) = (toPolar ((resA - resC), (resB - resD)))
   in
      (round (resE - resF))

finish_decoding : PartiallyDecoded -> Type
finish_decoding add_tile =
   {
      id = add_tile.id,
      name = add_tile.nam,
      crossing_cost = add_tile.ct
   }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> String -> Int -> Type
new id name crossing_cost =
   {
      id = id,
      name = name,
      crossing_cost = crossing_cost
   }

clone_instance : Struct.Location.Type -> Instance -> Instance
clone_instance loc inst = {inst | location = loc}

new_instance : Int -> Int -> Int -> Int -> Int -> Int -> Instance
new_instance x y type_id border_id variant_ix crossing_cost =
   {
      location = {x = x, y = y},
      type_id = type_id,
      border_id = border_id,
      variant_ix = variant_ix,
      crossing_cost = crossing_cost
   }

error_tile_instance : Int -> Int -> Instance
error_tile_instance x y =
   {
      location = {x = x, y = y},
      type_id = 0,
      border_id = 0,
      variant_ix = 0,
      crossing_cost = Constants.Movement.cost_when_out_of_bounds
   }

get_id : Type -> Int
get_id tile = tile.id

get_cost : Type -> Int
get_cost tile = tile.crossing_cost

get_instance_cost : Instance -> Int
get_instance_cost tile_inst = tile_inst.crossing_cost

get_name : Type -> String
get_name tile = tile.name

get_location : Instance -> Struct.Location.Type
get_location tile_inst = tile_inst.location

get_icon_id : Instance -> String
get_icon_id tile_inst =
   (
      (toString tile_inst.type_id)
      ++ "-"
      ++ (toString tile_inst.border_id)
      ++ "-"
      ++ (toString tile_inst.variant_ix)
   )

get_type_id : Instance -> Int
get_type_id tile_inst = tile_inst.type_id

get_variant_ix : Instance -> Int
get_variant_ix tile_inst =
   (
      (noise_function
         tile_inst.location.x
         tile_inst.location.y
         tile_inst.crossing_cost
      )
      % Constants.UI.local_variants_per_tile
   )

solve_tile_instance : (Dict.Dict Int Type) -> Instance -> Instance
solve_tile_instance tiles tile_instance =
   case (Dict.get tile_instance.type_id tiles) of
      (Just tile) ->
         {tile_instance | crossing_cost = tile.crossing_cost}

      Nothing ->
         (error_tile_instance
            tile_instance.location.x
            tile_instance.location.y
         )

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map
      (finish_decoding)
      (Json.Decode.Pipeline.decode
         PartiallyDecoded
         |> (Json.Decode.Pipeline.required "id" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "ct" Json.Decode.int)
      )
   )
