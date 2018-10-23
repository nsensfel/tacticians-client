module Struct.ServerReply exposing (Type(..))

-- Elm -------------------------------------------------------------------------

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
import Struct.Character
import Struct.Glyph
import Struct.GlyphBoard
import Struct.Inventory
import Struct.Portrait
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

type Type =
   Okay
   | Disconnected
   | SetInventory Struct.Inventory.Type
   | AddArmor Struct.Armor.Type
   | AddGlyph Struct.Glyph.Type
   | AddGlyphBoard Struct.GlyphBoard.Type
   | AddPortrait Struct.Portrait.Type
   | AddWeapon Struct.Weapon.Type
   | AddCharacter (Struct.Character.Type, String, Int, Int, Int)

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
