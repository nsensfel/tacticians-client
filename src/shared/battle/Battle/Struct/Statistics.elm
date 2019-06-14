module Battle.Struct.Statistics exposing
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
      decode_category,
      encode_category,
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

default : Type
default =
   {
      movement_points = 0,
      max_health = 1,
      dodges = 0,
      parries = 0,
      accuracy = 0,
      double_hits = 0,
      critical_hits = 0,
      damage_modifier = 0
   }

decode_category : String -> Category
decode_category str =
   case str of
      "mheal" -> MaxHealth
      "mpts" -> MovementPoints
      "dodg" -> Dodges
      "pary" -> Parries
      "accu" -> Accuracy
      "dhit" -> DoubleHits
      "dmgm" -> DamageModifier
      _  -> CriticalHits

encode_category : Category -> String
encode_category cat =
   case cat of
      MaxHealth -> "mheal"
      MovementPoints -> "mpts"
      Dodges -> "dodg"
      Parries -> "pary"
      Accuracy -> "accu"
      DoubleHits -> "dhit"
      CriticalHits -> "crit"
      DamageModifier -> "dmgm"

is_percent : Category -> Bool
is_percent cat = ((cat /= MaxHealth) && (cat /= MovementPoints))
