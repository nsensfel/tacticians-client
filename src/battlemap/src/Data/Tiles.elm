module Data.Tiles exposing (..)

-- TODO: should be given by the server, as all other Data.

import Constants.Movement

get_icon : Int -> String
get_icon i =
   toString(i)

get_cost : Int -> Int
get_cost i =
   case i of
      0 -> 6
      1 -> 12
      2 -> 24
      _ -> Constants.Movement.cost_when_out_of_bounds
