module Shim.Battlemap.Tile exposing (generate)

import Array
import List

import Battlemap.Direction
import Battlemap.Tile

from_int : Int -> Battlemap.Tile.Type
from_int i =
   if (i >= 10)
   then
      {
         floor_level = (i - 10),
         nav_level = Battlemap.Direction.None,
         char_level = (Just (toString (i - 10)))
      }
   else
      {
         floor_level = i,
         nav_level = Battlemap.Direction.None,
         char_level = Nothing
      }


generate : (Array.Array Battlemap.Tile.Type)
generate =
   (Array.fromList
      (List.map
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
