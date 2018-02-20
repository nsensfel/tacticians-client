module Struct.Weapon exposing
   (
      Type,
      new,
      get_max_range,
      get_min_range,
      none
   )

-- Battlemap -------------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : Int,
      range_min : Int,
      range_max : Int
   }

type WeaponRangeType = Ranged | Melee
type WeaponRangeModifier = Long | Sort
type WeaponDamageType = Slash | Blunt | Pierce

type alias WeaponType =
   {
      range : WeaponRangeType,
      range_mod : WeaponRangeModifier,
      dmg_type : WeaponDamageType
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> Type
new id =
   {
      id = id,
      range_min = 1,
      range_max = 1
   }

none : Type
none =
   {
      id = 0,
      range_min = 0,
      range_max = 0
   }

get_max_range : Type -> Int
get_max_range wp = wp.range_max

get_min_range : Type -> Int
get_min_range wp = wp.range_min
