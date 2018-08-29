module Struct.Armor exposing
   (
      Type,
      Ref,
      new,
      get_id,
      get_name,
      get_image_id,
      decoder,
      none
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Map -------------------------------------------------------------------
import Struct.Attributes
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : Int,
      name : String
   }

type alias Ref = Int

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> String -> Type
new id name =
   {
      id = id,
      name = name
   }

get_id : Type -> Ref
get_id ar = ar.id

get_name : Type -> String
get_name ar = ar.name

get_image_id : Type -> String
get_image_id ar = (toString ar.id)


decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map
      (finish_decoding)
      (Json.Decode.Pipeline.decode
         PartiallyDecoded
         |> (Json.Decode.Pipeline.required "id" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      )
   )

none : Type
none = (new 0 "None")
