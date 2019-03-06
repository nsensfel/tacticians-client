module Struct.Omnimods exposing
   (
      Type,
      none,
      get_attributes_mods,
      get_statistics_mods,
      get_attack_mods,
      get_defense_mods,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Map Editor ------------------------------------------------------------------
import Struct.Attributes
import Struct.Statistics
import Struct.DamageType

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      attributes : (Dict.Dict String Int),
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
      (Dict.fromList)
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "attm" generic_mods_decoder)
      |> (Json.Decode.Pipeline.required "stam" generic_mods_decoder)
      |> (Json.Decode.Pipeline.required "atkm" generic_mods_decoder)
      |> (Json.Decode.Pipeline.required "defm" generic_mods_decoder)
   )

none : Type
none =
   let empty_dict = (Dict.empty) in
   {
      attributes = empty_dict,
      statistics = empty_dict,
      attack = empty_dict,
      defense = empty_dict
   }

get_attributes_mods : Type -> (List (String, Int))
get_attributes_mods omnimods = (Dict.toList omnimods.attributes)

get_statistics_mods : Type -> (List (String, Int))
get_statistics_mods omnimods = (Dict.toList omnimods.statistics)

get_attack_mods : Type -> (List (String, Int))
get_attack_mods omnimods = (Dict.toList omnimods.attack)

get_defense_mods : Type -> (List (String, Int))
get_defense_mods omnimods = (Dict.toList omnimods.defense)
