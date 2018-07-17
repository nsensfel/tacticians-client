module Struct.Location exposing (..)

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Struct.Direction

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

neighbor : Struct.Direction.Type -> Type -> Type
neighbor dir loc =
   case dir of
      Struct.Direction.Right -> {loc | x = (loc.x + 1)}
      Struct.Direction.Left -> {loc | x = (loc.x - 1)}
      Struct.Direction.Up -> {loc | y = (loc.y - 1)}
      Struct.Direction.Down -> {loc | y = (loc.y + 1)}
      Struct.Direction.None -> loc

neighbors : Type -> (List Type)
neighbors loc =
   [
      {loc | x = (loc.x + 1)},
      {loc | x = (loc.x - 1)},
      {loc | y = (loc.y - 1)},
      {loc | y = (loc.y + 1)}
   ]

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
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "x" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "y" Json.Decode.int)
   )
