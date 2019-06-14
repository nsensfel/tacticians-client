module Battle.Struct.Omnimods exposing
   (
      Type,
      new,
      merge,
      none,
      apply_to_statistics,
      get_attack_damage,
      get_damage_sum,
      get_statistics_mods,
      get_attack_mods,
      get_defense_mods,
      get_all_mods,
      scale,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Statistics
import Battle.Struct.DamageType

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      statistics : (Dict.Dict String Int),
      attack : (Dict.Dict String Int),
      defense : (Dict.Dict String Int)
   }

type alias GenericMod =
   {
      t : String,
      v : Int
   }
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
generic_mods_decoder : (Json.Decode.Decoder (Dict.Dict String Int))
generic_mods_decoder =
   (Json.Decode.map
      ((Dict.fromList) >> (Dict.remove "none"))
      (Json.Decode.list
         (Json.Decode.map
            (\gm -> (gm.t, gm.v))
            (Json.Decode.succeed
               GenericMod
               |> (Json.Decode.Pipeline.required "t" Json.Decode.string)
               |> (Json.Decode.Pipeline.required "v" Json.Decode.int)
            )
         )
      )
   )

merge_mods : (
      (Dict.Dict String Int) ->
      (Dict.Dict String Int) ->
      (Dict.Dict String Int)
   )
merge_mods a_mods b_mods =
   (Dict.merge
      (Dict.insert)
      (\t -> \v_a  -> \v_b -> \r -> (Dict.insert t (v_a + v_b) r))
      (Dict.insert)
      a_mods
      b_mods
      (Dict.empty)
   )

scale_dict_value : Float -> String -> Int -> Int
scale_dict_value modifier entry_name value =
   (ceiling ((toFloat value) * modifier))
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "stam" generic_mods_decoder)
      |> (Json.Decode.Pipeline.required "atkm" generic_mods_decoder)
      |> (Json.Decode.Pipeline.required "defm" generic_mods_decoder)
   )

new : (
      (List (String, Int)) ->
      (List (String, Int)) ->
      (List (String, Int)) ->
      Type
   )
new statistic_mods attack_mods defense_mods =
   {
      statistics = (Dict.fromList statistic_mods),
      attack = (Dict.fromList attack_mods),
      defense = (Dict.fromList defense_mods)
   }

none : Type
none =
   {
      statistics = (Dict.empty),
      attack = (Dict.empty),
      defense = (Dict.empty)
   }

merge : Type -> Type -> Type
merge omni_a omni_b =
   {
      statistics = (merge_mods omni_a.statistics omni_b.statistics),
      attack = (merge_mods omni_a.attack omni_b.attack),
      defense = (merge_mods omni_a.defense omni_b.defense)
   }

apply_to_statistics : (
      Type ->
      Battle.Struct.Statistics.Type ->
      Battle.Struct.Statistics.Type
   )
apply_to_statistics omnimods statistics =
   (Dict.foldl
      (
         (Battle.Struct.Statistics.decode_category)
         >> (Battle.Struct.Statistics.mod)
      )
      statistics
      omnimods.statistics
   )

get_damage_sum : Type -> Int
get_damage_sum omni =
   (Dict.foldl (\t -> \v -> \result -> (result + v)) 0 omni.attack)

get_attack_damage : Float -> Type -> Type -> Int
get_attack_damage dmg_modifier atk_omni def_omni =
   let
      base_def =
         (
            case
               (Dict.get
                  (Battle.Struct.DamageType.encode
                     Battle.Struct.DamageType.Base
                  )
                  def_omni.defense
               )
            of
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
         0
         atk_omni.attack
      )

scale : Float -> Type -> Type
scale multiplier omnimods =
   {omnimods |
      statistics = (Dict.map (scale_dict_value multiplier) omnimods.statistics),
      attack = (Dict.map (scale_dict_value multiplier) omnimods.attack),
      defense =
         (Dict.map (scale_dict_value multiplier) omnimods.defense)
   }

get_statistics_mods : Type -> (List (String, Int))
get_statistics_mods omnimods = (Dict.toList omnimods.statistics)

get_attack_mods : Type -> (List (String, Int))
get_attack_mods omnimods = (Dict.toList omnimods.attack)

get_defense_mods : Type -> (List (String, Int))
get_defense_mods omnimods = (Dict.toList omnimods.defense)

get_all_mods : Type -> (List (String, Int))
get_all_mods omnimods =
   (
      (get_statistics_mods omnimods)
      ++ (get_attack_mods omnimods)
      ++ (get_defense_mods omnimods)
   )
