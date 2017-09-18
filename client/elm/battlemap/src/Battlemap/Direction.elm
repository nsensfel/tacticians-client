module Battlemap.Direction exposing (Direction(..), opposite_of)

type Direction =
   None
   | Left
   | Right
   | Up
   | Down

opposite_of : Direction -> Direction
opposite_of d =
   case d of
      Left -> Right
      Right -> Left
      Up -> Down
      Down -> Up
      None -> None
