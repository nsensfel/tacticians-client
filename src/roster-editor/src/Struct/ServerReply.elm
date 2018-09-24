module Struct.ServerReply exposing (Type(..))

-- Elm -------------------------------------------------------------------------

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
import Struct.Character
import Struct.Inventory
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

type Type =
   Okay
   | Disconnected
   | SetInventory Struct.Inventory.Type
   | AddArmor Struct.Armor.Type
   | AddWeapon Struct.Weapon.Type
   | AddCharacter (Struct.Character.Type, Int, Int, Int)

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
