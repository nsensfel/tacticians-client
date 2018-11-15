module Struct.Armor exposing
   (
      Type,
      Ref,
      new,
      get_id,
      get_name,
      get_image_id,
      get_omnimods,
      decoder,
      none
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Battle ----------------------------------------------------------------------
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
new : String -> String -> Struct.Omnimods.Type -> Type
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
get_image_id ar = (toString ar.id)

get_omnimods : Type -> Struct.Omnimods.Type
get_omnimods ar = ar.omnimods

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "omni" Struct.Omnimods.decoder)
   )

none : Type
none = (new "0" "None" (Struct.Omnimods.new [] [] [] []))
