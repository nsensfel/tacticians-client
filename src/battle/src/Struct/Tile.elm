module Struct.Tile exposing
   (
      Ref,
      VariantID,
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
      get_border_variant_id,
      get_cost,
      get_instance_cost,
      get_location,
      get_type_id,
      get_variant_id,
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
type alias Ref = String
type alias VariantID = String

type alias Type =
   {
      id : Ref,
      name : String,
      crossing_cost : Int,
      omnimods : Struct.Omnimods.Type
   }

type alias Border =
   {
      type_id : Ref,
      variant_id : VariantID
   }

type alias Instance =
   {
      location : Struct.Location.Type,
      crossing_cost : Int,
      type_id : Ref ,
      variant_id : VariantID,
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
new : Ref -> String -> Int -> Struct.Omnimods.Type -> Type
new id name crossing_cost omnimods =
   {
      id = id,
      name = name,
      crossing_cost = crossing_cost,
      omnimods = omnimods
   }

new_border : Ref -> VariantID -> Border
new_border a b =
   {
      type_id = a,
      variant_id = b
   }

new_instance : (
      Struct.Location.Type ->
      Ref ->
      VariantID ->
      Int ->
      (List Border) ->
      Instance
   )
new_instance location type_id variant_id crossing_cost borders =
   {
      location = location,
      type_id = type_id,
      variant_id = variant_id,
      crossing_cost = crossing_cost,
      borders = borders
   }

error_tile_instance : Int -> Int -> Instance
error_tile_instance x y =
   {
      location = {x = x, y = y},
      type_id = "0",
      variant_id = "0",
      crossing_cost = Constants.Movement.cost_when_out_of_bounds,
      borders = []
   }

get_id : Type -> Ref
get_id tile = tile.id

get_cost : Type -> Int
get_cost tile = tile.crossing_cost

get_instance_cost : Instance -> Int
get_instance_cost tile_inst = tile_inst.crossing_cost

get_name : Type -> String
get_name tile = tile.name

get_location : Instance -> Struct.Location.Type
get_location tile_inst = tile_inst.location

get_type_id : Instance -> Ref
get_type_id tile_inst = tile_inst.type_id

get_border_type_id : Border -> Ref
get_border_type_id tile_border = tile_border.type_id

get_borders : Instance -> (List Border)
get_borders tile_inst = tile_inst.borders

get_variant_id : Instance -> VariantID
get_variant_id tile_inst = tile_inst.variant_id

get_border_variant_id : Border -> VariantID
get_border_variant_id tile_border = tile_border.variant_id

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

solve_tile_instance : (Dict.Dict Ref Type) -> Instance -> Instance
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
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ct" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "omni" Struct.Omnimods.decoder)
   )
