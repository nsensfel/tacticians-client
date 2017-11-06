module Event exposing (Type(..))

import Dict

import Http

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
   | ServerReplied (Result Http.Error (Dict.Dict String (List String)))
   | DebugTeamSwitchRequest
