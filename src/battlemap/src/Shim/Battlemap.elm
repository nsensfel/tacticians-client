module Shim.Battlemap exposing (generate)

import Shim.Battlemap.Tile

--generate : Battlemap.Type
generate =
   {
      width = 16,
      height = 16,
      content = (Shim.Battlemap.Tile.generate 16),
      navigator = Nothing
   }
