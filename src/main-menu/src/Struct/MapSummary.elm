module Struct.MapSummary exposing
   (
      Type,
      get_id,
      get_name,
      decoder,
      none
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Main Menu -------------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      ix : Int,
      id : String,
      name : String
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_id : Type -> String
get_id t = t.id

get_name : Type -> String
get_name t = t.name

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
     Type
      |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "id" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "nme" Json.Decode.string)
   )

none : Type
none =
   {
      ix = -1,
      id = "",
      name = "Unknown"
   }
