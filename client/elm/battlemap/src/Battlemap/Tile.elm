module Battlemap.Tile exposing (Tile, generate, set_direction)

import Battlemap.Direction exposing (..)

import List exposing (map)
import Array exposing (Array, fromList)

type alias Tile =
   {
      floor_level : Int,
      nav_level : Direction
--      char_level : Int,
--      mod_level : Int
   }

set_direction : Direction -> Tile -> Tile
set_direction d t =
   {t | nav_level = d}

from_int : Int -> Tile
from_int i =
   {
      floor_level = i,
      nav_level = None
   }

generate : Int -> Int -> (Array Tile)
generate width height =
   (fromList
      (map
         (from_int)
         [
            1, 1, 1, 2, 2, 2,
            1, 0, 0, 0, 0, 2,
            1, 0, 1, 2, 0, 2,
            3, 0, 3, 4, 0, 4,
            3, 0, 0, 0, 0, 4,
            3, 3, 3, 4, 4, 4
         ]
      )
   )
