module Struct.Weapon exposing
   (
      Type,
      Ref,
      RangeType(..),
      RangeModifier(..),
      DamageType(..),
      DamageModifier(..),
      new,
      get_id,
      get_name,
      get_range_type,
      get_range_modifier,
      get_damage_type,
      get_damage_modifier,
      get_attack_range,
      get_defense_range,
      get_max_damage,
      get_min_damage,
      decoder,
      none,
      apply_to_attributes
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battlemap -------------------------------------------------------------------
import Struct.Attributes

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias PartiallyDecoded =
   {
      id : Int,
      nam : String,
      rt : String,
      rm : String,
      dt : String,
      dm : String,
      cf : Float
   }

type alias Type =
   {
      id : Int,
      name : String,
      coef : Float,
      range_type : RangeType,
      range_mod : RangeModifier,
      dmg_type : DamageType,
      dmg_mod : DamageModifier,
      def_range : Int,
      atk_range : Int,
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
      (Ranged, Short) -> (1, 4)
      (Melee, Long) -> (0, 2)
      (Melee, Short) -> (0, 1)

get_damages : Float -> RangeType -> DamageModifier -> (Int, Int)
get_damages coef rt dm =
   case (rt, dm) of
      (Ranged, Heavy) -> ((ceiling (10.0 * coef)), (ceiling (25.0 * coef)))
      (Ranged, Light) -> ((ceiling (5.0 * coef)), (ceiling (20.0 * coef)))
      (Melee, Heavy) -> ((ceiling (20.0 * coef)), (ceiling (35.0 * coef)))
      (Melee, Light) -> ((ceiling (15.0 * coef)), (ceiling (30.0 * coef)))

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : (
      Int ->
      String ->
      Float ->
      RangeType ->
      RangeModifier ->
      DamageType ->
      DamageModifier ->
      Type
   )
new
   id name coef
   range_type range_mod
   dmg_type dmg_mod
   =
   let
      (def_range, atk_range) = (get_ranges range_type range_mod)
      (dmg_min, dmg_max) = (get_damages coef range_type dmg_mod)
   in
   {
      id = id,
      name = name,
      coef = coef,
      range_type = range_type,
      range_mod = range_mod,
      dmg_type = dmg_type,
      dmg_mod = dmg_mod,
      def_range = def_range,
      atk_range = atk_range,
      dmg_min = dmg_min,
      dmg_max = dmg_max
   }

get_id : Type -> Int
get_id wp = wp.id

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

get_attack_range : Type -> Int
get_attack_range wp = wp.atk_range

get_defense_range : Type -> Int
get_defense_range wp = wp.def_range

get_max_damage : Type -> Int
get_max_damage wp = wp.dmg_max

get_min_damage : Type -> Int
get_min_damage wp = wp.dmg_min

apply_to_attributes : Type -> Struct.Attributes.Type -> Struct.Attributes.Type
apply_to_attributes wp atts =
   let
      impact = (-20.0 * wp.coef)
      full_impact = (ceiling impact)
      quarter_impact = (ceiling (impact / 4.0))
   in
      case (wp.range_mod, wp.dmg_mod) of
         (Long, Heavy) ->
            (Struct.Attributes.mod_dexterity
               full_impact
               (Struct.Attributes.mod_speed full_impact atts)
            )

         (Long, Light) ->
            (Struct.Attributes.mod_dexterity
               full_impact
               (Struct.Attributes.mod_speed quarter_impact atts)
            )

         (Short, Heavy) ->
            (Struct.Attributes.mod_dexterity
               quarter_impact
               (Struct.Attributes.mod_speed full_impact atts)
            )

         (Short, Light) ->
            (Struct.Attributes.mod_dexterity
               quarter_impact
               (Struct.Attributes.mod_speed quarter_impact atts)
            )

finish_decoding : PartiallyDecoded -> Type
finish_decoding add_weapon =
   (new
      add_weapon.id
      add_weapon.nam
      add_weapon.cf
      (
         case add_weapon.rt of
            "m" -> Melee
            _ -> Ranged
      )
      (
         case add_weapon.rm of
            "l" -> Long
            _ -> Short
      )
      (
         case add_weapon.dt of
            "s" -> Slash
            "p" -> Pierce
            _ -> Blunt
      )
      (
         case add_weapon.dm of
            "l" -> Light
            _ -> Heavy
      )
   )

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map
      (finish_decoding)
      (Json.Decode.Pipeline.decode
         PartiallyDecoded
         |> (Json.Decode.Pipeline.required "id" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "rt" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "rm" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "dt" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "dm" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "coef" Json.Decode.float)
      )
   )

none : Type
none =
   (new
      0
      "None"
      0.0
      Melee
      Short
      Blunt
      Light
   )
