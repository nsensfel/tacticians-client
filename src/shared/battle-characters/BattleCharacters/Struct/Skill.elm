module BattleCharacters.Struct.Skill exposing
   (
      Type,
      Ref,
      find,
      default,
      get_id,
      get_name,
      get_cost,
      get_reserve,
      get_locations,
      get_duration,
      get_uses,
      get_chance,
      get_power,
      get_range,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Dict

import Json.Decode
import Json.Decode.Pipeline

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : String,
      name : String,
      cost : Int,
      reserve : Int,
      targets : Int,
      locations : Int,
      duration : Int,
      uses : Int,
      chance : Int,
      power : Int,
      range : Int
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
      Nothing -> default

default : Type
default =
   {
      id = "",
      name = "Skill Not Found",
      cost = 999,
      reserve = 999,
      targets = -1,
      locations = -1,
      duration = -1,
      uses = -1,
      chance = -1,
      power = -1,
      range = -1
   }

get_id : Type -> String
get_id p = p.id

get_name : Type -> String
get_name p = p.name

get_cost : Type -> Int
get_cost p = p.cost

get_reserve : Type -> Int
get_reserve p = p.reserve

get_targets : Type -> Int
get_targets p = p.targets

get_locations : Type -> Int
get_locations p = p.locations

get_duration : Type -> Int
get_duration p = p.duration

get_uses : Type -> Int
get_uses p = p.uses

get_chance : Type -> Int
get_chance p = p.chance

get_power : Type -> Int
get_power p = p.power

get_range : Type -> Int
get_range p = p.range

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "cos" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "res" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "tar" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "loc" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "dur" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "use" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "cha" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "pow" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "ran" Json.Decode.int)
   )
