module Comm.AddChar exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Model
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

internal_decoder : (
      (Struct.Character.Type, Int, Int, Int) ->
      Struct.ServerReply.Type
   )
internal_decoder char_and_refs = (Struct.ServerReply.AddCharacter char_and_refs)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Struct.Model.Type -> (Json.Decode.Decoder Struct.ServerReply.Type))
decode model =
   (Json.Decode.map
      (internal_decoder)
      (Struct.Character.decoder)
   )
