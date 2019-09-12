module Battle.Struct.Attributes exposing
   (
      Type,
      Category(..),
      get_movement_points,
      get_max_health,
      get_dodges,
      get_parries,
      get_accuracy,
      get_double_hits,
      get_critical_hits,
      get_damage_modifier,
      get_damage_multiplier,
      get_true_movement_points,
      get_true_max_health,
      get_true_dodges,
      get_true_parries,
      get_true_accuracy,
      get_true_double_hits,
      get_true_critical_hits,
      get_true_damage_modifier,
      get,
      get_true,
      decode_category,
      encode_category,
      get_categories,
      mod,
      default,
      is_percent
   )

-- Elm -------------------------------------------------------------------------
import List

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Category =
   MovementPoints
   | MaxHealth
   | Dodges
   | Parries
   | Accuracy
   | DoubleHits
   | CriticalHits
   | DamageModifier

type alias Type =
   {
      movement_points : Int,
      max_health : Int,
      dodges : Int,
      parries : Int,
      accuracy : Int,
      double_hits : Int,
      critical_hits : Int,
      damage_modifier : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
mod_movement_points : Int -> Type -> Type
mod_movement_points v t =
   {t |
      movement_points = (t.movement_points + v)
   }

mod_max_health : Int -> Type -> Type
mod_max_health v t =
   {t |
      max_health = (t.max_health + v)
   }

mod_dodges : Int -> Type -> Type
mod_dodges v t = {t | dodges = (t.dodges + v)}

mod_parries : Int -> Type -> Type
mod_parries v t = {t | parries = (t.parries + v)}

mod_accuracy : Int -> Type -> Type
mod_accuracy v t = {t | accuracy = (t.accuracy + v)}

mod_double_hits : Int -> Type -> Type
mod_double_hits v t = {t | double_hits = (t.double_hits + v)}

mod_critical_hits : Int -> Type -> Type
mod_critical_hits v t = {t | critical_hits = (t.critical_hits + v)}

mod_damage_modifier : Int -> Type -> Type
mod_damage_modifier v t = {t | damage_modifier = (t.damage_modifier + v)}

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_movement_points : Type -> Int
get_movement_points t = (max 0 t.movement_points)

get_max_health : Type -> Int
get_max_health t = (max 1 t.max_health)

get_dodges : Type -> Int
get_dodges t = (max 0 t.dodges)

get_parries : Type -> Int
get_parries t = (max 0 t.parries)

get_accuracy : Type -> Int
get_accuracy t = (max 0 t.accuracy)

get_double_hits : Type -> Int
get_double_hits t = (max 0 t.double_hits)

get_critical_hits : Type -> Int
get_critical_hits t = (max 0 t.critical_hits)

get_damage_modifier : Type -> Int
get_damage_modifier t = (max 0 t.damage_modifier)

get_damage_multiplier : Type -> Float
get_damage_multiplier t = ((toFloat (max 0 t.damage_modifier)) / 100.0)

get_true_movement_points : Type -> Int
get_true_movement_points t = t.movement_points

get_true_max_health : Type -> Int
get_true_max_health t = t.max_health

get_true_dodges : Type -> Int
get_true_dodges t = t.dodges

get_true_parries : Type -> Int
get_true_parries t = t.parries

get_true_accuracy : Type -> Int
get_true_accuracy t = t.accuracy

get_true_double_hits : Type -> Int
get_true_double_hits t = t.double_hits

get_true_critical_hits : Type -> Int
get_true_critical_hits t = t.critical_hits

get_true_damage_modifier : Type -> Int
get_true_damage_modifier t = t.damage_modifier


mod : Category -> Int -> Type -> Type
mod cat v t =
   case cat of
      MaxHealth -> (mod_max_health v t)
      MovementPoints -> (mod_movement_points v t)
      Dodges -> (mod_dodges v t)
      Parries -> (mod_parries v t)
      Accuracy -> (mod_accuracy v t)
      DoubleHits -> (mod_double_hits v t)
      CriticalHits -> (mod_critical_hits v t)
      DamageModifier -> (mod_damage_modifier v t)

get : Category -> Type -> Int
get cat t =
   case cat of
      MaxHealth -> (get_max_health t)
      MovementPoints -> (get_movement_points t)
      Dodges -> (get_dodges t)
      Parries -> (get_parries t)
      Accuracy -> (get_accuracy t)
      DoubleHits -> (get_double_hits t)
      CriticalHits -> (get_critical_hits t)
      DamageModifier -> (get_damage_modifier t)

get_true : Category -> Type -> Int
get_true cat t =
   case cat of
      MaxHealth -> (get_true_max_health t)
      MovementPoints -> (get_true_movement_points t)
      Dodges -> (get_true_dodges t)
      Parries -> (get_true_parries t)
      Accuracy -> (get_true_accuracy t)
      DoubleHits -> (get_true_double_hits t)
      CriticalHits -> (get_true_critical_hits t)
      DamageModifier -> (get_true_damage_modifier t)

get_categories : (List Category)
get_categories =
   [
      MovementPoints,
      MaxHealth,
      Dodges,
      Parries,
      Accuracy,
      DoubleHits,
      CriticalHits,
      DamageModifier
   ]

m4_include(__MAKEFILE_DATA_DIR/attributes.m4.conf)

default : Type
default =
   {
      movement_points = __ATT_MOVEMENT_POINTS_MIN,
      max_health = __ATT_MAX_HEALTH_MIN,
      dodges = __ATT_DODGE_MIN,
      parries = __ATT_PARRY_MIN,
      accuracy = __ATT_ACCURACY_MIN,
      double_hits = __ATT_DOUBLE_HITS_MIN,
      critical_hits = __ATT_CRITICAL_HIT_MIN,
      damage_modifier = __ATT_DAMAGE_MODIFIER_MIN
   }


m4_include(__MAKEFILE_DATA_DIR/names.m4.conf)

decode_category : String -> Category
decode_category str =
   case str of
      "__SN_MAX_HEALTH" -> MaxHealth
      "__SN_MOVEMENT_POINTS" -> MovementPoints
      "__SN_DODGE" -> Dodges
      "__SN_PARRY" -> Parries
      "__SN_ACCURACY" -> Accuracy
      "__SN_DOUBLE_HITS" -> DoubleHits
      "__SN_DAMAGE_MODIFIER" -> DamageModifier
      _  -> CriticalHits

encode_category : Category -> String
encode_category cat =
   case cat of
      MaxHealth -> "__SN_MAX_HEALTH"
      MovementPoints -> "__SN_MOVEMENT_POINTS"
      Dodges -> "__SN_DODGE"
      Parries -> "__SN_PARRY"
      Accuracy -> "__SN_ACCURACY"
      DoubleHits -> "__SN_DOUBLE_HITS"
      CriticalHits -> "__SN_CRITICAL_HIT"
      DamageModifier -> "__SN_DAMAGE_MODIFIER"

is_percent : Category -> Bool
is_percent cat = ((cat /= MaxHealth) && (cat /= MovementPoints))
