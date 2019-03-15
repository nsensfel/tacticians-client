module Struct.Event exposing (Type(..), attempted)

-- Elm -------------------------------------------------------------------------
import Http

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Struct.Error
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
   | CharacterOrTileSelected BattleMap.Struct.Location.Ref
   | CharacterSelected Int
   | DebugLoadBattleRequest
   | DebugTeamSwitchRequest
   | DebugTestAnimation
   | DirectionRequested BattleMap.Struct.Direction.Type
   | Failed Struct.Error.Type
   | GoToMainMenu
   | LookingForCharacter Int
   | None
   | RequestedHelp Struct.HelpRequest.Type
   | ScaleChangeRequested Float
   | ServerReplied (Result Http.Error (List Struct.ServerReply.Type))
   | TabSelected Struct.UI.Tab
   | TileSelected BattleMap.Struct.Location.Ref
   | TurnEnded
   | UndoActionRequest
   | WeaponSwitchRequest

attempted : (Result.Result err val) -> Type
attempted act =
   case act of
      (Result.Ok _) -> None
      (Result.Err msg) ->
         (Failed
            (Struct.Error.new
               Struct.Error.Failure
               -- TODO: find a way to get some relevant text here.
               "(text representation not implemented)"
            )
         )
