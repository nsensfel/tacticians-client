module BattleCharacters.Struct.Glyph exposing
   (
      Type,
      Ref,
      find,
      get_name,
      get_id,
      get_omnimods,
      none,
      default,
      decoder
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

get_id : Type -> Ref
get_id g = g.id

get_name : Type -> String
get_name g = g.name

get_omnimods : Type -> Battle.Struct.Omnimods.Type
get_omnimods g = g.omnimods

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "omni" Battle.Struct.Omnimods.decoder)
   )

none : Type
none =
   {
      id = "0",
      name = "Empty",
      omnimods = (Battle.Struct.Omnimods.none)
   }

default : Type
default = (none)
