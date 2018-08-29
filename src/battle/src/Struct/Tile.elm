module Struct.Tile exposing
   (
      Ref,
      Type,
      Instance,
      Border,
      new,
      new_instance,
      new_border,
      error_tile_instance,
      get_id,
      get_name,
      get_borders,
      get_border_type_id,
      get_border_variant_ix,
      get_cost,
      get_instance_cost,
      get_location,
      get_type_id,
      get_variant_ix,
      get_local_variant_ix,
      get_omnimods,
      solve_tile_instance,
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
type alias Ref = Int

type alias Type =
   {
      id : Int,
      name : String,
      crossing_cost : Int,
      omnimods : Struct.Omnimods.Type
   }

type alias Border =
   {
      type_id : Int,
      variant_ix : Int
   }

type alias Instance =
   {
      location : Struct.Location.Type,
      crossing_cost : Int,
      type_id : Int,
      variant_ix : Int,
      borders : (List Border)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
noise_function : Int -> Int -> Int -> Int
noise_function a b c =
   (round (radians (toFloat ((a + 1) * 2 + (b + 1) * 3 + c))))

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> String -> Int -> Struct.Omnimods.Type -> Type
new id name crossing_cost omnimods =
   {
      id = id,
      name = name,
      crossing_cost = crossing_cost,
      omnimods = omnimods
   }

new_border : Int -> Int -> Border
new_border a b =
   {
      type_id = a,
      variant_ix = b
   }

new_instance : (
      Struct.Location.Type ->
      Int ->
      Int ->
      Int ->
      (List Border) ->
      Instance
   )
new_instance location type_id variant_ix crossing_cost borders =
   {
      location = location,
      type_id = type_id,
      variant_ix = variant_ix,
      crossing_cost = crossing_cost,
      borders = borders
   }

error_tile_instance : Int -> Int -> Instance
error_tile_instance x y =
   {
      location = {x = x, y = y},
      type_id = 0,
      variant_ix = 0,
      crossing_cost = Constants.Movement.cost_when_out_of_bounds,
      borders = []
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

get_type_id : Instance -> Int
get_type_id tile_inst = tile_inst.type_id

get_border_type_id : Border -> Int
get_border_type_id tile_border = tile_border.type_id

get_borders : Instance -> (List Border)
get_borders tile_inst = tile_inst.borders

get_variant_ix : Instance -> Int
get_variant_ix tile_inst = tile_inst.variant_ix

get_border_variant_ix : Border -> Int
get_border_variant_ix tile_border = tile_border.variant_ix

get_local_variant_ix : Instance -> Int
get_local_variant_ix tile_inst =
   (
      (noise_function
         tile_inst.location.x
         tile_inst.location.y
         tile_inst.crossing_cost
      )
      % Constants.UI.local_variants_per_tile
   )

get_omnimods : Type -> Struct.Omnimods.Type
get_omnimods t = t.omnimods

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
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ct" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "omni" Struct.Omnimods.decoder)
   )
