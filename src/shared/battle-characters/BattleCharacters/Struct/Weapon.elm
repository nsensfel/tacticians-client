module BattleCharacters.Struct.Weapon exposing
   (
      Type,
      Ref,
      find,
      get_id,
      get_name,
      get_is_primary,
      get_attack_range,
      get_defense_range,
      get_omnimods,
      decoder,
      default,
      none
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : String,
      name : String,
      is_primary : Bool,
      def_range : Int,
      atk_range : Int,
      omnimods : Battle.Struct.Omnimods.Type
   }

type alias Ref = String

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
find : (Dict.Dict Ref Type) -> Ref -> Type
find dict ref =
   case (Dict.get ref dict) of
      (Just e) -> e
      Nothing -> none

get_id : Type -> String
get_id wp = wp.id

get_name : Type -> String
get_name wp = wp.name

get_is_primary : Type -> Bool
get_is_primary wp = wp.is_primary

get_attack_range : Type -> Int
get_attack_range wp = wp.atk_range

get_defense_range : Type -> Int
get_defense_range wp = wp.def_range

get_omnimods : Type -> Battle.Struct.Omnimods.Type
get_omnimods wp = wp.omnimods

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "pri" Json.Decode.bool)
      |> (Json.Decode.Pipeline.required "rmi" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "rma" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "omni" Battle.Struct.Omnimods.decoder)
   )

none : Type
none =
   {
      id = "",
      name = "None",
      is_primary = False,
      def_range = 0,
      atk_range = 0,
      omnimods = (Battle.Struct.Omnimods.none)
   }

default : Type
default = (none)
