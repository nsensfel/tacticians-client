module Event exposing (Type(..))

import Battlemap.Direction
import Battlemap.Location

import Character

import UI

type Type =
   DirectionRequested Battlemap.Direction.Type
   | TileSelected Battlemap.Location.Ref
   | CharacterSelected Character.Ref
   | TurnEnded
   | ScaleChangeRequested Float
   | TabSelected UI.Tab
   | DebugTeamSwitchRequest
