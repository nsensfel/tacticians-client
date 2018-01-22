module Struct.Statistics exposing
   (
      Type,
      get_movement_points,
      get_max_health,
      get_dodges,
      get_parries,
      get_damage_min,
      get_damage_max,
      get_accuracy,
      get_double_hits,
      get_critical_hits,
      new
   )

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      movement_points : Int,
      max_health : Int,
      dodges : Int,
      parries : Int,
      damage_min : Int,
      damage_max : Int,
      accuracy : Int,
      double_hits : Int,
      critical_hits : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_movement_points : Type -> Int
get_movement_points t = t.movement_points

get_max_health : Type -> Int
get_max_health t = t.max_health

get_dodges : Type -> Int
get_dodges t = t.dodges

get_parries : Type -> Int
get_parries = t.parries

get_damage_min : Type -> Int
get_damage_min = t.damage_min

get_damage_max : Type -> Int
get_damage_max = t.damage_max

get_accuracy : Type -> Int
get_accuracy = t.accuracy

get_double_hits : Type -> Int
get_double_hits = t.double_hits

get_critical_hits : Type -> Int
get_critical_hits = t.critical_hits

new : (
      Struct.Attributes.Type ->
      Struct.Weapon.Type ->
      Type
   )
new con dex int min spe str =
   {
      constitution = con,
      dexterity = dex,
      intelligence = int,
      mind = min,
      speed = spe,
      strength = str
   }
