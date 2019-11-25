module Struct.ServerReply exposing (Type(..))

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.DataSetItem

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSetItem
import BattleMap.Struct.Map

-- Local Module ----------------------------------------------------------------
import Struct.Player
import Struct.Character
import Struct.TurnResult

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   Okay
   | Disconnected

   | AddPlayer Struct.Player.Type
   | AddCharacter Struct.Character.Unresolved
   | SetMap BattleMap.Struct.Map.Type
   | TurnResults (List Struct.TurnResult.Type)
   | SetTimeline (List Struct.TurnResult.Type)

   | AddMapDataSetItem BattleMap.Struct.DataSetItem.Type
   | AddCharactersDataSetItem BattleCharacters.Struct.DataSetItem.Type

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
