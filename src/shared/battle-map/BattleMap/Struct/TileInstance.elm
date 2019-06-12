module BattleMap.Struct.TileInstance exposing
   (
      Type,
      Border,
      clone,
      get_location,
      get_class_id,
      get_family,
      get_cost,
      default,
      set_borders,
      get_borders,
      new_border,
      get_variant_id,
      get_border_variant_id,
      get_border_class_id,
      get_local_variant_ix,
      remove_trigger,
      add_trigger,
      get_triggers,
      error,
      solve,
      set_location_from_index,
      decoder,
      encode
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Set

import Json.Encode

import Json.Decode
import Json.Decode.Pipeline

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Tile
import BattleMap.Struct.Location

-- Local -----------------------------------------------------------------------
import Constants.UI
import Constants.Movement


--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      location : BattleMap.Struct.Location.Type,
      crossing_cost : Int,
      family : BattleMap.Struct.Tile.FamilyID,
      class_id : BattleMap.Struct.Tile.Ref,
      variant_id : BattleMap.Struct.Tile.VariantID,
      triggers : (Set.Set String),
      borders : (List Border)
   }

type alias Border =
   {
      class_id : BattleMap.Struct.Tile.Ref,
      variant_id : BattleMap.Struct.Tile.VariantID
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
clone : BattleMap.Struct.Location.Type -> Type -> Type
clone loc inst = {inst | location = loc}

new_border : (
      BattleMap.Struct.Tile.Ref ->
      BattleMap.Struct.Tile.VariantID ->
      Border
   )
new_border class_id variant_id =
   {
      class_id = class_id,
      variant_id = variant_id
   }

default : BattleMap.Struct.Tile.Type -> Type
default tile =
   {
      location = {x = 0, y = 0},
      class_id = (BattleMap.Struct.Tile.get_id tile),
      variant_id = "0",
      crossing_cost = (BattleMap.Struct.Tile.get_cost tile),
      family = (BattleMap.Struct.Tile.get_family tile),
      triggers = (Set.empty),
      borders = []
   }

error : Int -> Int -> Type
error x y =
   {
      location = {x = x, y = y},
      class_id = "0",
      variant_id = "0",
      family = "0",
      crossing_cost = Constants.Movement.cost_when_out_of_bounds,
      triggers = (Set.empty),
      borders = []
   }

get_class_id : Type -> BattleMap.Struct.Tile.Ref
get_class_id inst = inst.class_id

get_cost : Type -> Int
get_cost inst = inst.crossing_cost

get_location : Type -> BattleMap.Struct.Location.Type
get_location inst = inst.location

get_family : Type -> BattleMap.Struct.Tile.FamilyID
get_family inst = inst.family

set_borders : (List Border) -> Type -> Type
set_borders borders tile_inst = {tile_inst | borders = borders}

get_borders : Type -> (List Border)
get_borders tile_inst = tile_inst.borders

get_variant_id : Type -> BattleMap.Struct.Tile.VariantID
get_variant_id tile_inst = tile_inst.variant_id

get_border_variant_id : Border -> BattleMap.Struct.Tile.VariantID
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

solve : (
      (Dict.Dict BattleMap.Struct.Tile.Ref BattleMap.Struct.Tile.Type) ->
      Type ->
      Type
   )
solve tiles tile_inst =
   case (Dict.get tile_inst.class_id tiles) of
      (Just tile) ->
         {tile_inst |
            crossing_cost = (BattleMap.Struct.Tile.get_cost tile),
            family = (BattleMap.Struct.Tile.get_family tile)
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
            ({ class_id = a, variant_id = b } :: borders)
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
                        (Json.Decode.map
                           (Set.fromList)
                           (Json.Decode.list (Json.Decode.string))
                        )
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

get_border_class_id : Border -> BattleMap.Struct.Tile.Ref
get_border_class_id tile_border = tile_border.class_id

set_location_from_index : Int -> Int -> Type -> Type
set_location_from_index map_width index tile_inst =
   {tile_inst |
      location =
            {
               x = (modBy map_width index),
               y = (index // map_width)
            }
   }

encode : Type -> Json.Encode.Value
encode tile_inst =
   (Json.Encode.object
      [
         (
            "b",
            (Json.Encode.list
               (Json.Encode.string)
               (
                  tile_inst.class_id
                  ::
                  (
                     tile_inst.variant_id
                     ::
                     (List.concatMap
                        (\border ->
                           [
                              border.class_id,
                              border.variant_id
                           ]
                        )
                        tile_inst.borders
                     )
                  )
               )
            )
         ),
         (
            "t",
            (Json.Encode.list
               (Json.Encode.string)
               (Set.toList tile_inst.triggers)
            )
         )
      ]
   )

get_triggers : Type -> (Set.Set String)
get_triggers tile_inst = tile_inst.triggers

add_trigger : String -> Type -> Type
add_trigger trigger tile_inst =
   {tile_inst |
      triggers = (Set.insert trigger tile_inst.triggers)
   }

remove_trigger : String -> Type -> Type
remove_trigger trigger tile_inst =
   {tile_inst |
      triggers = (Set.remove trigger tile_inst.triggers)
   }
