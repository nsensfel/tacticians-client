module BattleCharacters.Struct.StatusIndicator exposing
   (
      Type,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Set

import Json.Decode
import Json.Decode.Pipeline

-- Battle Character ------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Visibility =
   None
   | Limited (Set.Set Int)
   | All

type alias Type =
   {
      ix : Int,
      category : String,
      parameter : String
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "i" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "c" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "p" Json.Decode.string)
   )
