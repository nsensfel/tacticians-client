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

from_ref : Ref -> Type
from_ref (x, y) =
   {x = x, y = y}

dist : Type -> Type -> Int
dist loc_a loc_b =
   if (loc_a.x > loc_b.x)
   then
      if (loc_a.y > loc_b.y)
      then
         ((loc_a.x - loc_b.x) + (loc_a.y - loc_b.y))
      else
         ((loc_a.x - loc_b.x) + (loc_b.y - loc_a.y))
   else
      if (loc_a.y > loc_b.y)
      then
         ((loc_b.x - loc_a.x) + (loc_a.y - loc_b.y))
      else
         ((loc_b.x - loc_a.x) + (loc_b.y - loc_a.y))
