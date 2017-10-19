module Battlemap.Direction exposing (Type(..), opposite_of, to_string)

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

to_string : Type -> String
to_string dir =
   case dir of
      Right -> "R"
      Left -> "L"
      Up -> "U"
      Down -> "D"
      None -> "N"

