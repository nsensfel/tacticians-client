module Struct.Omnimods exposing
   (
      Type,
      new,
      merge,
      apply_to_attributes,
      apply_to_statistics,
      get_attack_damage,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Map -------------------------------------------------------------------
import Struct.Attributes
import Struct.Statistics
import Struct.DamageType

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      attributes : (Dict.Dict Struct.Attributes.Category Int),
      statistics : (Dict.Dict Struct.Statistics.Category Int),
      attack : (Dict.Dict Struct.DamageType.Type Int),
      defense : (Dict.Dict Struct.DamageType.Type Int)
   }

type alias GenericMod =
   {
      t : String,
      v : Int
   }
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
generic_mod_decoder : (Json.Decode.Decoder GenericMod)
generic_mod_decoder =
   (Json.Decode.Pipeline.decode
      GenericMod
      |> (Json.Decode.Pipeline.required "t" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "v" Json.Decode.int)
   )

generic_mod_to_attribute_mod : GenericMod -> (Struct.Attributes.Category, Int)
generic_mod_to_attribute_mod genm =
   ((Struct.Attributes.decode_category genm.t), genm.v)

attribute_mods_decoder : (
      (Json.Decode.Decoder (Dict.Dict Struct.Attributes.Category Int))
   )
attribute_mods_decoder =
   (Json.Decode.map
      (Dict.fromList)
      (Json.Decode.list
         (Json.Decode.map (generic_mod_to_attribute_mod) generic_mod_decoder)
      )
   )

generic_mod_to_statistic_mod : GenericMod -> (Struct.Attributes.Category, Int)
generic_mod_to_statistic_mod genm =
   ((Struct.Statistics.decode_category genm.t), genm.v)

statistic_mods_decoder : (
      (Json.Decode.Decoder (Dict.Dict Struct.Statistics.Category Int))
   )
statistic_mods_decoder =
   (Json.Decode.map
      (Dict.fromList)
      (Json.Decode.list
         (Json.Decode.map (generic_mod_to_statistic_mod) generic_mod_decoder)
      )
   )

generic_mod_to_damage_mod : GenericMod -> (Struct.DamageType.Type, Int)
generic_mod_to_damage_mod genm =
   ((Struct.DamageType.decode genm.t), genm.v)

damage_mods_decoder : (
      (Json.Decode.Decoder (Dict.Dict Struct.DamageType.Type Int))
   )
damage_mods_decoder =
   (Json.Decode.map
      (Dict.fromList)
      (Json.Decode.list
         (Json.Decode.map (generic_mod_to_damage_mod) generic_mod_decoder)
      )
   )

merge_mods : (Dict.Dict a Int) -> (Dict.Dict a Int) -> (Dict.Dict a Int)
merge_mods a_mods b_mods =
   (Dict.merge
      (Dict.insert)
      (\t -> \v_a  -> \v_b -> (Dict.insert t (v_a + v_b)))
      (Dict.insert)
      a_mods
      b_mods
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "attm" attribute_mods_decoder)
      |> (Json.Decode.Pipeline.required "stam" statistic_mods_decoder)
      |> (Json.Decode.Pipeline.required "atkm" damage_mods_decoder)
      |> (Json.Decode.Pipeline.required "defm" damage_mods_decoder)
   )

new : (
      (List (Struct.Attributes.Category, Int)) ->
      (List (Struct.Statistics.Category, Int)) ->
      (List (Struct.DamageType.Type, Int)) ->
      (List (Struct.DamageType.Type, Int)) ->
      Type
   )
new attribute_mods statistic_mods attack_mods defense_mods =
   {
      attributes = (Dict.fromList attribute_mods),
      statistics = (Dict.fromList statistic_mods),
      attack = (Dict.fromList attack_mods),
      defense = (Dict.fromList defense_mods)
   }

merge : Type -> Type -> Type
merge omni_a omni_b =
   {
      attributes = (merge_mods omni_a.attributes omni_b.attributes),
      statistics = (merge_mods omni_a.statistics omni_b.statistics),
      attack = (merge_mods omni_a.attack omni_b.attack),
      defense = (merge_mods omni_a.defense omni_b.defense)
   }

apply_to_attributes : Type -> Struct.Attributes.Type -> Struct.Attributes.Type
apply_to_attributes omnimods attributes =
   (Dict.foldl (Struct.Attributes.mod) attributes omnimods.attributes)

apply_to_statistics : Type -> Struct.Statistics.Type -> Struct.Statistics.Type
apply_to_statistics omnimods statistics =
   (Dict.foldl (Struct.Statistics.mod) statistics omnimods.statistics)

get_attack_damage : Int -> Type -> Type -> Int
get_attack_damage dmg_modifier atk_omni def_omni =
   let
      base_def =
         (
            case (Dict.get Struct.DamageType.Base def_omni.defense) of
               (Just v) -> v
               Nothing -> 0
         )
   in
      (Dict.foldl
         (\t -> \v -> \result ->
            let
               actual_atk =
                  (max
                     0
                     (
                        (ceiling ((toFloat v) * dmg_modifier))
                        - base_def
                     )
                  )
            in
               case (Dict.get t def_omni.defense) of
                  (Just def_v) -> (result + (max 0 (actual_atk - def_v)))
                  Nothing -> (result + actual_atk)
         )
         atk_omni.attack
      )
