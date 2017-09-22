module Battlemap.Location exposing (..)

import Battlemap.Direction

type alias Type =
   {
      x : Int,
      y : Int
   }

type alias Ref = (Int, Int)

neighbor : Type -> Battlemap.Direction.Type -> Type
neighbor loc dir =
   case dir of
      Battlemap.Direction.Right -> {loc | x = (loc.x + 1)}
      Battlemap.Direction.Left -> {loc | x = (loc.x - 1)}
      Battlemap.Direction.Up -> {loc | y = (loc.y - 1)}
      Battlemap.Direction.Down -> {loc | y = (loc.y + 1)}
      Battlemap.Direction.None -> loc

get_ref : Type -> Ref
get_ref l =
   (l.x, l.y)
