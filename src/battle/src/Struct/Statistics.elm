module Struct.Statistics exposing
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
      decode_category,
      new
   )

-- Elm -------------------------------------------------------------------------
import List

-- Battle ----------------------------------------------------------------------
import Struct.Attributes

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

type alias Type =
   {
      movement_points : Int,
      max_health : Int,
      dodges : Int,
      parries : Int,
      accuracy : Int,
      double_hits : Int,
      critical_hits : Int,
      damage_modifier : Float
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
average : (List Int) -> Float
average l = ((toFloat (List.sum l)) / (toFloat (List.length l)))

float_to_int : Float -> Int
float_to_int f =
   (ceiling f)

gentle_squared_growth : Int -> Int
gentle_squared_growth v = (float_to_int (((toFloat v)^1.8)/20.0))

gentle_squared_growth_f : Float -> Int
gentle_squared_growth_f v = (float_to_int ((v^1.8)/20.0))

sudden_squared_growth : Int -> Int
sudden_squared_growth v = (float_to_int (((toFloat v)^2.5)/1000.0))

sudden_squared_growth_f : Float -> Int
sudden_squared_growth_f v = (float_to_int ((v^2.5)/1000.0))

sudden_exp_growth : Int -> Int
sudden_exp_growth v = (float_to_int (4.0^((toFloat v)/25.0)))

sudden_exp_growth_f : Float -> Int
sudden_exp_growth_f f = (float_to_int (4.0^(f/25.0)))

damage_base_mod : Float -> Float
damage_base_mod str = (((str^1.8)/2000.0) - 0.75)

make_movement_points_safe  : Int -> Int
make_movement_points_safe val -> (clamp 0 200 val)

make_max_health_safe : Int -> Int
make_max_health_safe val -> (max 1 val)

make_dodges_safe : Int -> Int
make_dodges_safe val -> (clamp 0 100 val)

make_parries_safe : Int -> Int
make_parries_safe val -> (clamp 0 75 val)

make_accuracy_safe : Int -> Int
make_accuracy_safe val -> (clamp 0 100 val)

make_double_hits_safe : Int -> Int
make_double_hits_safe val -> (clamp 0 100 val)

make_critical_hits_safe : Int -> Int
make_critical_hits_safe val = (clamp 0 100 val)

mod_movement_points : Int -> Type -> Type
mod_movement_points v t =
   {t |
      movement_points = (make_movement_points_safe (t.movement_points + v))
   }

mod_max_health : Int -> Type -> Type
mod_max_health v t =
   {t |
      max_health = (make_max_health_safe (t.max_health + v))
   }

mod_dodges : Int -> Type -> Type
mod_dodges v t = {t | dodges = (make_dodges_safe (t.dodges + v))}

mod_parries : Int -> Type -> Type
mod_parries v t = {t | parries = (make_parries_safe (t.parries + v))}

mod_accuracy : Int -> Type -> Type
mod_accuracy v t = {t | accuracy = (make_accuracy_safe (t.accuracy + v))}

mod_double_hits : Int -> Type -> Type
mod_double_hits v t =
   {t |
      double_hits = (make_double_hits_safe (t.double_hits + v))
   }

mod_critical_hits : Int -> Type -> Type
mod_critical_hits v t =
   {t |
      critical_hits = (make_critical_hits_safe (t.critical_hits + v))
   }

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
get_parries t = t.parries

get_damage_min : Type -> Int
get_damage_min t = t.damage_min

get_damage_max : Type -> Int
get_damage_max t = t.damage_max

get_accuracy : Type -> Int
get_accuracy t = t.accuracy

get_double_hits : Type -> Int
get_double_hits t = t.double_hits

get_critical_hits : Type -> Int
get_critical_hits t = t.critical_hits

get_damage_modifier : Type -> Float
get_damage_modifier t = t.damage_modifier

new_raw : (Struct.Attributes.Type -> Type)
new_raw att =
   let
      constitution = (Struct.Attributes.get_constitution att)
      dexterity = (Struct.Attributes.get_dexterity att)
      intelligence = (Struct.Attributes.get_intelligence att)
      mind = (Struct.Attributes.get_mind att)
      speed = (Struct.Attributes.get_speed att)
      strength = (Struct.Attributes.get_strength att)
   in
      {
         movement_points =
            (gentle_squared_growth_f
               (average [mind, constitution, constitution, speed, speed, speed])
            ),
         max_health =
            (gentle_squared_growth_f
               (average [constitution, constitution, constitution, mind])
            ),
         dodges = (sudden_exp_growth_f (average [dexterity, mind, speed])),
         parries =
            (sudden_exp_growth_f
               (average [dexterity, intelligence, speed, strength])
            ),
         accuracy = (sudden_squared_growth dexterity),
         double_hits = (sudden_squared_growth_f (average [mind, speed])),
         critical_hits = (sudden_squared_growth intelligence),
         damage_modifier = (damage_base_mod (toFloat strength))
      }

decode_category : String -> Type
decode_category str =
   case str of
      "mheal" -> MaxHealth
      "mpts" -> MovementPoints
      "dodg" -> Dodges
      "pary" -> Parries
      "accu" -> Accuracy
      "dhit" -> DoubleHits
      _  -> CriticalHits
