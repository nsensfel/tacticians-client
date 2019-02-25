module Struct.TileInstance exposing
   (
      Type,
      Border,
      clone,
      get_class_id,
      get_family,
      default,
      new_border,
      error,
      solve,
      set_location_from_index,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Map Editor ------------------------------------------------------------------
import Constants.UI
import Constants.Movement

import Struct.Tile
import Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      location : Struct.Location.Type,
      crossing_cost : Int,
      family : Struct.Tile.FamilyID,
      type_id : Struct.Tile.Ref,
      variant_id : Struct.Tile.VariantID,
      triggers : (List String),
      borders : (List Border)
   }

type alias Border =
   {
      type_id : Struct.Tile.Ref,
      variant_id : Struct.Tile.VariantID
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
clone : Struct.Location.Type -> Type -> Type
clone loc inst = {inst | location = loc}

new_border : Struct.Tile.Ref -> Struct.Tile.VariantID -> Border
new_border type_id variant_id =
   {
      type_id = type_id,
      variant_id = variant_id
   }

default : Struct.Tile.Type -> Type
default tile =
   {
      location = {x = 0, y = 0},
      type_id = (Struct.Tile.get_id tile),
      variant_id = "0",
      crossing_cost = (Struct.Tile.get_cost tile),
      family = (Struct.Tile.get_family tile),
      triggers = [],
      borders = []
   }

error : Int -> Int -> Type
error x y =
   {
      location = {x = x, y = y},
      type_id = "0",
      variant_id = "0",
      family = "0",
      crossing_cost = Constants.Movement.cost_when_out_of_bounds,
      triggers = [],
      borders = []
   }

get_class_id : Type -> Struct.Tile.Ref
get_class_id inst = inst.type_id

get_cost : Type -> Int
get_cost inst = inst.crossing_cost

get_location : Type -> Struct.Location.Type
get_location inst = inst.location

get_family : Type -> Struct.Tile.FamilyID
get_family inst = inst.family

set_borders : (List Border) -> Type -> Type
set_borders borders tile_inst = {tile_inst | borders = borders}

get_borders : Type -> (List Border)
get_borders tile_inst = tile_inst.borders

get_variant_id : Type -> Struct.Tile.VariantID
get_variant_id tile_inst = tile_inst.variant_id

get_border_variant_id : Border -> Struct.Tile.VariantID
get_border_variant_id tile_border = tile_border.variant_id

get_local_variant_ix : Type -> Int
get_local_variant_ix tile_inst =
   (modBy
      Constants.UI.local_variants_per_tile
      (noise_function
         tile_inst.location.x
         tile_inst.location.y
         tile_inst.crossing_cost
      )
   )

solve : (Dict.Dict Struct.Tile.Ref Struct.Tile.Type) -> Type -> Type
solve tiles tile_inst =
   case (Dict.get tile_inst.type_id tiles) of
      (Just tile) ->
         {tile_inst |
            crossing_cost = (Struct.Tile.get_cost tile),
            family = (Struct.Tile.get_family tile)
         }

      Nothing ->
         {tile_inst |
            crossing_cost = -1,
            family = "-1"
         }


list_to_borders : (
      (List String) ->
      (List Border) ->
      (List Border)
   )
list_to_borders list borders =
   case list of
      (a :: (b :: c)) ->
         (list_to_borders
            c
            ({ type_id = a, variant_id = b } :: borders)
         )
      _ -> (List.reverse borders)

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.andThen
      (\tile_data ->
         case tile_data of
            (tile_id :: (variant_id :: borders)) ->
               (Json.Decode.succeed
                  Type
                  |> (Json.Decode.Pipeline.hardcoded {x = 0, y = 0}) -- Location
                  |> (Json.Decode.Pipeline.hardcoded 0) -- Crossing Cost
                  |> (Json.Decode.Pipeline.hardcoded "") -- Family
                  |> (Json.Decode.Pipeline.hardcoded tile_id)
                  |> (Json.Decode.Pipeline.hardcoded variant_id)
                  |>
                     (Json.Decode.Pipeline.required
                        "t"
                        (Json.Decode.list (Json.Decode.string))
                     )
                  |>
                     (Json.Decode.Pipeline.hardcoded
                        (list_to_borders borders [])
                     )
               )
            _ -> (Json.Decode.succeed (error 0 0))
      )
      (Json.Decode.field "b" (Json.Decode.list (Json.Decode.string)))
   )

get_border_type_id : Border -> Struct.Tile.Ref
get_border_type_id tile_border = tile_border.type_id

set_location_from_index : Int -> Int -> Type -> Type
set_location_from_index map_width index tile_inst =
   {tile_inst |
      location =
            {
               x = (modBy map_width index),
               y = (index // map_width)
            }
   }
