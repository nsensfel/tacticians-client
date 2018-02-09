module Data.Tile exposing (..)

import Constants.Movement

get_icon : Int -> String
get_icon i =
   toString(i)

get_cost : Int -> Int
get_cost i =
   if (i <= 200)
   then
      (i + 8)
   else
      Constants.Movement.cost_when_out_of_bounds
