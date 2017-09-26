module Event exposing (Type(..))

import Battlemap
import Battlemap.Direction
import Battlemap.Location

import Character

type Type =
   DirectionRequest Battlemap.Direction.Type
   | SelectTile Battlemap.Location.Ref
   | SelectCharacter Character.Ref
   | EndTurn
