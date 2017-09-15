module Battlemap.Location exposing (..)

import Battlemap.Direction exposing (..)

type alias Location =
   {
      x : Int,
      y : Int
   }

type alias LocationComparable = (Int, Int)

neighbor : Location -> Direction -> Location
neighbor loc dir =
   case dir of
      Right -> {loc | x = (loc.x + 1)}
      Left -> {loc | x = (loc.x - 1)}
      Up -> {loc | y = (loc.y - 1)}
      Down -> {loc | y = (loc.y + 1)}
      None -> loc

to_comparable : Location -> (Int, Int)
to_comparable l =
   (l.x, l.y)
