module Struct.Event exposing (Type(..), attempted)

-- Elm -------------------------------------------------------------------------
import Http

-- Map -------------------------------------------------------------------
import Struct.Direction
import Struct.Error
import Struct.Location
import Struct.ServerReply
import Struct.HelpRequest
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   AbortTurnRequest
   | AnimationEnded
   | AttackWithoutMovingRequest
   | CharacterInfoRequested Int
   | CharacterSelected Int
   | DebugLoadBattleRequest
   | DebugTeamSwitchRequest
   | DebugTestAnimation
   | DirectionRequested Struct.Direction.Type
   | Failed Struct.Error.Type
   | LookingForCharacter Int
   | None
   | ScaleChangeRequested Float
   | ServerReplied (Result Http.Error (List Struct.ServerReply.Type))
   | TabSelected Struct.UI.Tab
   | TileSelected Struct.Location.Ref
   | CharacterOrTileSelected Struct.Location.Ref
   | TurnEnded
   | RequestedHelp Struct.HelpRequest.Type
   | WeaponSwitchRequest
   | GoToMainMenu

attempted : (Result.Result err val) -> Type
attempted act =
   case act of
      (Result.Ok _) -> None
      (Result.Err msg) ->
         (Failed (Struct.Error.new Struct.Error.Failure (toString msg)))
