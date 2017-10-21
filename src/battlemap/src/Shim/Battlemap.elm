module Shim.Battlemap exposing (generate)

import Shim.Battlemap.Tile

--generate : Battlemap.Type
generate =
   {
      width = 64,
      height = 64,
      content = (Shim.Battlemap.Tile.generate 64),
      navigator = Nothing
   }
