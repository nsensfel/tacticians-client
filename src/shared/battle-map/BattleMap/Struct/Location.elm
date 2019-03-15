module BattleMap.Struct.Location exposing (..)

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

import Json.Encode

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
