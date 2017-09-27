module Shim.Battlemap exposing (generate)

import Shim.Battlemap.Tile

--generate : Battlemap.Type
generate =
   {
      width = 32,
      height = 32,
      content = (Shim.Battlemap.Tile.generate 32)
   }
