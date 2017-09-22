module Battlemap.Direction exposing (Type(..), opposite_of)

type Type =
   None
   | Left
   | Right
   | Up
   | Down

opposite_of : Type -> Type
opposite_of d =
   case d of
      Left -> Right
      Right -> Left
      Up -> Down
      Down -> Up
      None -> None
