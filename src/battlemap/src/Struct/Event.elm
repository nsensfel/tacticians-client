module Struct.Event exposing (Type(..))

-- Elm -------------------------------------------------------------------------
import Http

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Direction
import Struct.Location
import Struct.ServerReply
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   DirectionRequested Struct.Direction.Type
   | TileSelected Struct.Location.Ref
   | CharacterSelected Struct.Character.Ref
   | CharacterInfoRequested Struct.Character.Ref
   | TurnEnded
   | ScaleChangeRequested Float
   | TabSelected Struct.UI.Tab
   | ServerReplied (Result Http.Error (List Struct.ServerReply.Type))
   | DebugTeamSwitchRequest
   | DebugLoadBattlemapRequest
   | WeaponSwitchRequest
   | AttackWithoutMovingRequest
   | AbortTurnRequest
