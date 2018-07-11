module Struct.Tile exposing
   (
      Ref,
      Type,
      Instance,
      new,
      new_instance,
      error_tile_instance,
      get_id,
      get_name,
      get_range_minimum,
      get_range_maximum,
      get_cost,
      get_instance_cost,
      get_location,
      get_icon_id,
      get_type_id,
      get_variant_id,
      solve_tile_instance,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import List

import Json.Decode
import Json.Decode.Pipeline

-- Map -------------------------------------------------------------------
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
      ct : Int,
      rmi : Int,
      rma : Int
   }

type alias Type =
   {
      id : Int,
      name : String,
      crossing_cost : Int,
      range_minimum : Int,
      range_maximum : Int
   }

type alias Instance =
   {
      location : Struct.Location.Type,
      icon_id : Int,
      crossing_cost : Int,
      type_id : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
noise_function : Int -> Int -> Int -> Int
noise_function a b c =
   (round (radians (toFloat ((a + 1) * 2 + (b + 1) * 3 + c))))

finish_decoding : PartiallyDecoded -> Type
finish_decoding add_tile =
   {
      id = add_tile.id,
      name = add_tile.nam,
      crossing_cost = add_tile.ct,
      range_minimum = add_tile.rmi,
      range_maximum = add_tile.rma
   }

seek_tile_instance_type : Instance -> Type -> (Maybe Type) -> (Maybe Type)
seek_tile_instance_type instance candidate current_sol =
   if (current_sol == Nothing)
   then
      let
         icon_id = instance.icon_id
      in
         if
         (
            (icon_id >= candidate.range_minimum)
            && (icon_id <= candidate.range_maximum)
         )
         then
            (Just candidate)
         else
            current_sol
   else
      current_sol

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> String -> Int -> Int -> Int -> Type
new id name crossing_cost range_minimum range_maximum =
   {
      id = id,
      name = name,
      crossing_cost = crossing_cost,
      range_minimum = range_minimum,
      range_maximum = range_maximum
   }

new_instance : Int -> Int -> Int -> Int -> Int -> Instance
new_instance x y icon_id crossing_cost type_id =
   {
      location = {x = x, y = y},
      icon_id = icon_id,
      crossing_cost = crossing_cost,
      type_id = type_id
   }

error_tile_instance : Int -> Int -> Instance
error_tile_instance x y =
   {
      location = {x = x, y = y},
      icon_id = -1,
      type_id = -1,
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

get_range_minimum : Type -> Int
get_range_minimum tile = tile.range_minimum

get_range_maximum : Type -> Int
get_range_maximum tile = tile.range_maximum

get_location : Instance -> Struct.Location.Type
get_location tile_inst = tile_inst.location

get_icon_id : Instance -> String
get_icon_id tile_inst = (toString tile_inst.icon_id)

get_type_id: Instance -> Int
get_type_id tile_inst = tile_inst.type_id

get_variant_id : Instance -> Int
get_variant_id tile_inst =
   (
      (noise_function
         tile_inst.location.x
         tile_inst.location.y
         tile_inst.crossing_cost
      )
      % Constants.UI.variants_per_tile
   )

solve_tile_instance : (List Type) -> Instance -> Instance
solve_tile_instance tiles tile_instance =
   let
      maybe_type =
         (List.foldr (seek_tile_instance_type tile_instance) Nothing tiles)
   in
      case maybe_type of
         (Just tile) ->
            {tile_instance |
               type_id = tile.id,
               crossing_cost = tile.crossing_cost
            }

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
         |> (Json.Decode.Pipeline.required "rmi" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "rma" Json.Decode.int)
      )
   )
