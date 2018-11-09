module Struct.Glyph exposing
   (
      Type,
      Ref,
      get_name,
      get_id,
      get_omnimods,
      none,
      default,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Roster Editor ---------------------------------------------------------------
import Struct.Omnimods

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : String,
      name : String,
      omnimods : Struct.Omnimods.Type
   }

type alias Ref = String

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_id : Type -> String
get_id g = g.id

get_name : Type -> String
get_name g = g.name

get_omnimods : Type -> Struct.Omnimods.Type
get_omnimods g = g.omnimods

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "omni" Struct.Omnimods.decoder)
   )

none : Type
none =
   {
      id = "0",
      name = "Empty",
      omnimods = (Struct.Omnimods.none)
   }

default : Type
default = (none)
