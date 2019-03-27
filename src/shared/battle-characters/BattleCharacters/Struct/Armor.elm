module BattleCharacters.Struct.Armor exposing
   (
      Type,
      Ref,
      new,
      find,
      get_id,
      get_name,
      get_image_id,
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

new : String -> String -> Battle.Struct.Omnimods.Type -> Type
new id name omnimods =
   {
      id = id,
      name = name,
      omnimods = omnimods
   }

get_id : Type -> Ref
get_id ar = ar.id

get_name : Type -> String
get_name ar = ar.name

get_image_id : Type -> String
get_image_id ar = ar.id

get_omnimods : Type -> Battle.Struct.Omnimods.Type
get_omnimods ar = ar.omnimods

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "omni" Battle.Struct.Omnimods.decoder)
   )

none : Type
none = (new "0" "None" (Battle.Struct.Omnimods.none))

default : Type
default = (none)
