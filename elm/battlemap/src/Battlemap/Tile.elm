module Battlemap.Tile exposing
   (
      Type,
      get_class,
      get_cost
   )

import Battlemap.Location

type alias Type =
   {
      location : Battlemap.Location.Ref,
      class : Int,
      crossing_cost : Int
   }

get_class : Type -> Int
get_class tile = tile.class

get_cost : Type -> Int
get_cost tile = tile.crossing_cost
