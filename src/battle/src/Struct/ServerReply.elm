module Struct.ServerReply exposing (Type(..))

-- Elm -------------------------------------------------------------------------

-- Battle ----------------------------------------------------------------------
import Struct.Armor
import Struct.Map
import Struct.Character
import Struct.Tile
import Struct.TurnResult
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

type Type =
   Okay
   | Disconnected
   | AddArmor Struct.Armor.Type
   | AddWeapon Struct.Weapon.Type
   | AddCharacter
      (
         Struct.Character.Type,
         Struct.Weapon.Ref,
         Struct.Weapon.Ref,
         Struct.Armor.Ref
      )
   | AddTile Struct.Tile.Type
   | SetMap Struct.Map.Type
   | TurnResults (List Struct.TurnResult.Type)
   | SetTimeline (List Struct.TurnResult.Type)

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
