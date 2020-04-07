module Comm.AddChar exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : Struct.Character.Unresolved -> Struct.ServerReply.Type
internal_decoder ref = (Struct.ServerReply.AddCharacter ref)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.andThen
      (\ix ->
         (Json.Decode.map
            (internal_decoder)
            (Json.Decode.field "cha" (Struct.Character.decoder ix))
         )
      )
      (Json.Decode.field "ix" (Json.Decode.int))
   )
