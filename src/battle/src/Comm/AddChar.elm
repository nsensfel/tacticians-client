module Comm.AddChar exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Map -------------------------------------------------------------------
import Struct.Character
import Struct.Weapon
import Struct.Armor
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

internal_decoder : (
      Struct.Character.TypeAndEquipementRef ->
      Struct.ServerReply.Type
   )
internal_decoder char_and_refs = (Struct.ServerReply.AddCharacter char_and_refs)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode = (Json.Decode.map (internal_decoder) (Struct.Character.decoder))
