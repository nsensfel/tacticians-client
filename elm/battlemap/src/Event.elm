module Event exposing (Type(..))

import Battlemap
import Battlemap.Direction
import Battlemap.Location

import Character

type Type =
   DirectionRequested Battlemap.Direction.Type
   | TileSelected Battlemap.Location.Ref
   | CharacterSelected Character.Ref
   | TurnEnded
