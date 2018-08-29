module Struct.Omnimods exposing
   (
      Type,
      new,
      merge,
      apply_to_attributes,
      apply_to_statistics,
      get_attack_damage,
      decode
   )

-- Elm -------------------------------------------------------------------------
import Json.Decode
import Json.Decode.Pipeline

-- Map -------------------------------------------------------------------
import Struct.Attributes
import Struct.Statistics
import Struct.DamageType

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      attributes : (Dict.Dict Struct.Attributes.Category Int),
      statistics : (Dict.Dict Struct.Statistics.Category Int),
      attack : (Dict.Dict Struct.DamageType.Type Int),
      defense : (Dict.Dict Struct.DamageType.Type Int)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.map
      (finish_decoding)
      (Json.Decode.Pipeline.decode
         PartiallyDecoded
         |> (Json.Decode.Pipeline.required "id" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "ct" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "cf" Json.Decode.float)
      )
   )
