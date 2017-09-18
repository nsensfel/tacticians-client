module Battlemap.Tile exposing (Tile, generate, set_direction)

import Battlemap.Direction exposing (Direction(..))
import Character exposing (CharacterRef)

import List exposing (map)
import Array exposing (Array, fromList)
import Set exposing (Set)

type alias Tile =
   {
      floor_level : Int,
      nav_level : Direction,
      char_level : (Maybe CharacterRef)
--    mod_level : (Set TileModifier)
   }

set_direction : Direction -> Tile -> Tile
set_direction d t =
   {t |
      nav_level = d
   }

from_int : Int -> Tile
from_int i =
   if (i >= 10)
   then
      {
         floor_level = (i - 10),
         nav_level = None,
         char_level = (Just (toString (i - 10)))
      }
   else
      {
         floor_level = i,
         nav_level = None,
         char_level = Nothing
      }


generate : Int -> Int -> (Array Tile)
generate width height =
   (fromList
      (map
         (from_int)
         [
            10,   1,    1,    2,    2,    2,
            1,    0,    0,    0,    11,   2,
            1,    0,    1,    2,    0,    2,
            3,    0,    3,    4,    0,    4,
            3,    12,   0,    0,    0,    4,
            3,    3,    3,    4,    4,    4
         ]
      )
   )
