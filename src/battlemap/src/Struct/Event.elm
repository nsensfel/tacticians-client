module Struct.Event exposing (Type(..), attempted)

-- Elm -------------------------------------------------------------------------
import Http

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Direction
import Struct.Error
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
   | None
   | Failed Struct.Error.Type

attempted : (Result.Result err val) -> Type
attempted act =
   case act of
      (Result.Ok _) -> None
      (Result.Err msg) ->
         (Failed (Struct.Error.new Struct.Error.Failure (toString msg)))
