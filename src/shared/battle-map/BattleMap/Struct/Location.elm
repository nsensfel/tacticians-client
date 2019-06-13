module BattleMap.Struct.Location exposing (..)

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

import Json.Encode

import Set

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      x : Int,
      y : Int
   }

type alias Ref = (Int, Int)

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> Int -> Type
new x y =
   {
      x = x,
      y = y
   }

neighbor : BattleMap.Struct.Direction.Type -> Type -> Type
neighbor dir loc =
   case dir of
      BattleMap.Struct.Direction.Right -> {loc | x = (loc.x + 1)}
      BattleMap.Struct.Direction.Left -> {loc | x = (loc.x - 1)}
      BattleMap.Struct.Direction.Up -> {loc | y = (loc.y - 1)}
      BattleMap.Struct.Direction.Down -> {loc | y = (loc.y + 1)}
      BattleMap.Struct.Direction.None -> loc

get_ref : Type -> Ref
get_ref l =
   (l.x, l.y)

from_ref : Ref -> Type
from_ref (x, y) =
   {x = x, y = y}

dist : Type -> Type -> Int
dist loc_a loc_b =
   (
      (abs (loc_a.x - loc_b.x))
      +
      (abs (loc_a.y - loc_b.y))
   )

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "x" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "y" Json.Decode.int)
   )

encode : Type -> Json.Encode.Value
encode loc =
   (Json.Encode.object
      [
         ( "x", (Json.Encode.int loc.x) ),
         ( "y", (Json.Encode.int loc.y) )
      ]
   )

neighbors : Type -> (List Type)
neighbors loc =
   [
      {loc | x = (loc.x + 1)},
      {loc | x = (loc.x - 1)},
      {loc | y = (loc.y - 1)},
      {loc | y = (loc.y + 1)}
   ]

get_full_neighborhood : Type -> (List Type)
get_full_neighborhood loc =
   [
      {loc | x = (loc.x - 1), y = (loc.y - 1)},
      {loc | y = (loc.y - 1)},
      {loc | x = (loc.x + 1), y = (loc.y - 1)},
      {loc | x = (loc.x - 1)},
      {loc | x = (loc.x + 1)},
      {loc | x = (loc.x - 1), y = (loc.y + 1)},
      {loc | y = (loc.y + 1)},
      {loc | x = (loc.x + 1), y = (loc.y + 1)}
   ]

add_neighborhood_to_set : (
      Int ->
      Int ->
      Int ->
      Type ->
      (Set.Set Ref) ->
      (Set.Set Ref)
   )
add_neighborhood_to_set map_width map_height tdist loc set =
   (List.foldl
      (\height_mod current_width_result ->
         let
            abs_width_mod = (abs (tdist - (abs height_mod)))
            current_height = (loc.y + height_mod)
         in
            if ((current_height < 0) || (current_height >= map_height))
            then current_width_result
            else
               (List.foldl
                  (\width_mod current_result ->
                     let new_location_x = (loc.x + width_mod) in
                        if
                        (
                           (new_location_x < 0)
                           || (new_location_x >= map_width)
                        )
                        then current_result
                        else
                           (Set.insert
                              (new_location_x, current_height)
                              current_result
                           )
                  )
                  current_width_result
                  (List.range (-abs_width_mod) abs_width_mod)
               )
      )
      set
      (List.range (-tdist) tdist)
   )
