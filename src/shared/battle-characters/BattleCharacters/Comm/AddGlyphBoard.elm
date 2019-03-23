module BattleCharacters.Comm.AddGlyphBoard exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.GlyphBoard

-- Local Module-----------------------------------------------------------------
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : (
      BattleCharacters.Struct.GlyphBoard.Type ->
      Struct.ServerReply.Type
   )
internal_decoder glb = (Struct.ServerReply.AddGlyphBoard glb)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.map
      (internal_decoder)
      (BattleCharacters.Struct.GlyphBoard.decoder)
   )
