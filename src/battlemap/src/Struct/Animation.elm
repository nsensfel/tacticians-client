module Struct.Animation exposing
   (
      Type
   )

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Direction
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias CharMoves =
   {
      char_ix : Int,
      dir : Struct.Direction.Type
   }

type alias CharSwitchesWeapon =
   {
      char_ix : Int
      new_weapon_id : Struct.Weapon.Ref
   }

type alias CharAttacks =
   {
      char_ix : Int,
      target_ix : Int,
      sequence : (List Struct.Attack.Type)
   }

type Type =
   CharacterMoves CharMoves
   | CharacterSwitchesWeapon CharSwitchesWeapon
   | CharacterAttacks CharAttacks

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
