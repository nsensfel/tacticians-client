module Struct.Event exposing (Type(..), attempted)

-- Elm -------------------------------------------------------------------------
import Http

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Tile

-- Local Module ----------------------------------------------------------------
import Struct.Error
import Struct.HelpRequest
import Struct.ServerReply
import Struct.Toolbox
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   None
   | Failed Struct.Error.Type
   | ScaleChangeRequested Float
   | ServerReplied (Result Http.Error (List Struct.ServerReply.Type))
   | TabSelected Struct.UI.Tab
   | TileSelected BattleMap.Struct.Location.Ref
   | RequestedHelp Struct.HelpRequest.Type
   | ModeRequested Struct.Toolbox.Mode
   | ShapeRequested Struct.Toolbox.Shape
   | ClearSelectionRequested
   | TemplateRequested
      (BattleMap.Struct.Tile.Ref, BattleMap.Struct.Tile.VariantID)
   | PrettifySelectionRequested
   | SendMapUpdateRequested
   | GoToMainMenu

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
