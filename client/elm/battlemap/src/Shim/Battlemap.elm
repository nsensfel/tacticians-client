module Shim.Battlemap exposing (generate)

import Shim.Battlemap.Tile

--generate : Battlemap.Type
generate =
   {
      width = 6,
      height = 6,
      content = (Shim.Battlemap.Tile.generate)
   }
