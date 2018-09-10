module Struct.WeaponSet exposing
   (
      Type,
      new,
      get_active_weapon,
      get_secondary_weapon,
      switch_weapons
   )

-- Map -------------------------------------------------------------------
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      active : Struct.Weapon.Type,
      secondary : Struct.Weapon.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Struct.Weapon.Type -> Struct.Weapon.Type -> Type
new wp0 wp1 = { active = wp0, secondary = wp1 }

get_active_weapon : Type -> Struct.Weapon.Type
get_active_weapon set = set.active

get_secondary_weapon : Type -> Struct.Weapon.Type
get_secondary_weapon set = set.secondary

switch_weapons : Type -> Type
switch_weapons set = {set | active = set.secondary, secondary = set.active}
