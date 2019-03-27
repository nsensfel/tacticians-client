module Struct.ServerReply exposing (Type(..))

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.GlyphBoard

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Inventory

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

type Type =
   Okay
   | Disconnected
   | GoTo String
   | SetInventory Struct.Inventory.Type
   | AddArmor BattleCharacters.Struct.Armor.Type
   | AddGlyph BattleCharacters.Struct.Glyph.Type
   | AddGlyphBoard BattleCharacters.Struct.GlyphBoard.Type
   | AddPortrait BattleCharacters.Struct.Portrait.Type
   | AddWeapon BattleCharacters.Struct.Weapon.Type
   | AddCharacter Struct.Character.Unresolved

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
