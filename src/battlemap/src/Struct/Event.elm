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
   AbortTurnRequest
   | AttackWithoutMovingRequest
   | CharacterInfoRequested Struct.Character.Ref
   | CharacterSelected Struct.Character.Ref
   | DebugLoadBattlemapRequest
   | DebugTeamSwitchRequest
   | DirectionRequested Struct.Direction.Type
   | Failed Struct.Error.Type
   | LookingForCharacter Struct.Character.Ref
   | None
   | ScaleChangeRequested Float
   | ServerReplied (Result Http.Error (List Struct.ServerReply.Type))
   | TabSelected Struct.UI.Tab
   | TileSelected Struct.Location.Ref
   | TurnEnded
   | WeaponSwitchRequest

attempted : (Result.Result err val) -> Type
attempted act =
   case act of
      (Result.Ok _) -> None
      (Result.Err msg) ->
         (Failed (Struct.Error.new Struct.Error.Failure (toString msg)))
