module Struct.Weapon exposing
   (
      Type,
      Ref,
      RangeType(..),
      RangeModifier(..),
      DamageType(..),
      DamageModifier(..),
      new,
      get_name,
      get_range_type,
      get_range_modifier,
      get_damage_type,
      get_damage_modifier,
      get_max_range,
      get_min_range,
      get_max_damage,
      get_min_damage,
      apply_to_attributes
   )

-- Battlemap -------------------------------------------------------------------
import Struct.Attributes

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : Int,
      name : String,
      range_type : RangeType,
      range_mod : RangeModifier,
      dmg_type : DamageType,
      dmg_mod : DamageModifier,
      range_min : Int,
      range_max : Int,
      dmg_min : Int,
      dmg_max : Int
   }

type alias Ref = Int

type RangeType = Ranged | Melee
type RangeModifier = Long | Short
-- Having multiple types at the same time, like Warframe does, would be nice.
type DamageType = Slash | Blunt | Pierce
type DamageModifier = Heavy | Light

type alias WeaponType =
   {
      range : RangeType,
      range_mod : RangeModifier,
      dmg_type : DamageType
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_ranges : RangeType -> RangeModifier -> (Int, Int)
get_ranges rt rm =
   case (rt, rm) of
      (Ranged, Long) -> (2, 6)
      (Ranged, Short) -> (2, 4)
      (Melee, Long) -> (1, 2)
      (Melee, Short) -> (1, 1)

get_damages : RangeType -> DamageModifier -> (Int, Int)
get_damages rt dm =
   case (rt, dm) of
      (Ranged, Heavy) -> (10, 25)
      (Ranged, Light) -> (5, 20)
      (Melee, Heavy) -> (20, 35)
      (Melee, Light) -> (15, 30)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : (
      Int ->
      String ->
      RangeType ->
      RangeModifier ->
      DamageType ->
      DamageModifier ->
      Type
   )
new
   id name
   range_type range_mod
   dmg_type dmg_mod
   =
   let
      (range_min, range_max) = (get_ranges range_type range_mod)
      (dmg_min, dmg_max) = (get_damages range_type dmg_mod)
   in
   {
      id = id,
      name = name,
      range_type = range_type,
      range_mod = range_mod,
      dmg_type = dmg_type,
      dmg_mod = dmg_mod,
      range_min = range_min,
      range_max = range_max,
      dmg_min = dmg_min,
      dmg_max = dmg_max
   }

get_name : Type -> String
get_name wp = wp.name

get_range_type : Type -> RangeType
get_range_type wp = wp.range_type

get_range_modifier : Type -> RangeModifier
get_range_modifier wp = wp.range_mod

get_damage_type : Type -> DamageType
get_damage_type wp = wp.dmg_type

get_damage_modifier : Type -> DamageModifier
get_damage_modifier wp = wp.dmg_mod

get_max_range : Type -> Int
get_max_range wp = wp.range_max

get_min_range : Type -> Int
get_min_range wp = wp.range_min

get_max_damage : Type -> Int
get_max_damage wp = wp.dmg_max

get_min_damage : Type -> Int
get_min_damage wp = wp.dmg_min

apply_to_attributes : Type -> Struct.Attributes.Type -> Struct.Attributes.Type
apply_to_attributes wp atts =
   case (wp.range_mod, wp.dmg_mod) of
      (Long, Heavy) ->
         (Struct.Attributes.mod_dexterity
            -20
            (Struct.Attributes.mod_speed -20 atts)
         )

      (Long, Light) ->  (Struct.Attributes.mod_dexterity -20 atts)

      (Short, Heavy) -> (Struct.Attributes.mod_speed -20 atts)

      (Short, Light) -> atts
