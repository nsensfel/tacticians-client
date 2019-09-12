module Battle.Struct.Omnimods exposing
   (
      Type,
      new,
      merge,
      merge_attributes,
      none,
      apply_to_attributes,
      get_attack_damage,
      get_damage_sum,
      get_attribute_mods,
      get_attribute_mod,
      get_attack_mods,
      get_defense_mods,
      get_all_mods,
      apply_damage_modifier,
      scale,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes
import Battle.Struct.DamageType

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      attributes : (Dict.Dict String Int),
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
      |> (Json.Decode.Pipeline.required "attm" generic_mods_decoder)
      |> (Json.Decode.Pipeline.required "atkm" generic_mods_decoder)
      |> (Json.Decode.Pipeline.required "defm" generic_mods_decoder)
   )

new : (
      (List (String, Int)) ->
      (List (String, Int)) ->
      (List (String, Int)) ->
      Type
   )
new attribute_mods attack_mods defense_mods =
   {
      attributes = (Dict.fromList attribute_mods),
      attack = (Dict.fromList attack_mods),
      defense = (Dict.fromList defense_mods)
   }

none : Type
none =
   {
      attributes = (Dict.empty),
      attack = (Dict.empty),
      defense = (Dict.empty)
   }

merge : Type -> Type -> Type
merge omni_a omni_b =
   {
      attributes = (merge_mods omni_a.attributes omni_b.attributes),
      attack = (merge_mods omni_a.attack omni_b.attack),
      defense = (merge_mods omni_a.defense omni_b.defense)
   }

merge_attributes : Battle.Struct.Attributes.Type -> Type -> Type
merge_attributes attributes omnimods =
   (merge
      omnimods
      (new
         (List.map
            (\att ->
               (
                  (Battle.Struct.Attributes.encode_category att),
                  (Battle.Struct.Attributes.get_true att attributes)
               )
            )
            (Battle.Struct.Attributes.get_categories)
         )
         []
         []
      )
   )

apply_to_attributes : (
      Type ->
      Battle.Struct.Attributes.Type ->
      Battle.Struct.Attributes.Type
   )
apply_to_attributes omnimods attributes =
   (Dict.foldl
      (
         (Battle.Struct.Attributes.decode_category)
         >> (Battle.Struct.Attributes.mod)
      )
      attributes
      omnimods.attributes
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

apply_damage_modifier : Int -> Type -> Type
apply_damage_modifier damage_modifier omnimods =
   {omnimods |
      attack =
         (Dict.map
            (scale_dict_value ((toFloat damage_modifier) / 100.0))
            omnimods.attack
         )
   }

scale : Float -> Type -> Type
scale multiplier omnimods =
   {omnimods |
      attributes = (Dict.map (scale_dict_value multiplier) omnimods.attributes),
      attack = (Dict.map (scale_dict_value multiplier) omnimods.attack),
      defense =
         (Dict.map (scale_dict_value multiplier) omnimods.defense)
   }

get_attribute_mod : Battle.Struct.Attributes.Category -> Type -> Int
get_attribute_mod att omnimods =
   case
      (Dict.get
         (Battle.Struct.Attributes.encode_category att)
         omnimods.attributes
      )
   of
      (Just e) -> e
      Nothing -> 0

get_attribute_mods : Type -> (List (String, Int))
get_attribute_mods omnimods = (Dict.toList omnimods.attributes)

get_attack_mods : Type -> (List (String, Int))
get_attack_mods omnimods = (Dict.toList omnimods.attack)

get_defense_mods : Type -> (List (String, Int))
get_defense_mods omnimods = (Dict.toList omnimods.defense)

get_all_mods : Type -> (List (String, Int))
get_all_mods omnimods =
   (
      (get_attribute_mods omnimods)
      ++ (get_attack_mods omnimods)
      ++ (get_defense_mods omnimods)
   )
