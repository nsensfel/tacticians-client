module Struct.ServerReply exposing (Type(..))

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.Tile

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
   | AddArmor BattleCharacters.Struct.Armor.Type
   | AddPortrait BattleCharacters.Struct.Portrait.Type
   | AddPlayer Struct.Player.Type
   | AddWeapon BattleCharacters.Struct.Weapon.Type
   | AddCharacter Struct.Character.TypeAndEquipmentRef
   | AddTile BattleMap.Struct.Tile.Type
   | SetMap BattleMap.Struct.Map.Type
   | TurnResults (List Struct.TurnResult.Type)
   | SetTimeline (List Struct.TurnResult.Type)

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
