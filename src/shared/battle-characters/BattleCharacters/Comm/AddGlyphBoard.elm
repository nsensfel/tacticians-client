module BattleCharacters.Comm.AddGlyphBoard exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.DataSetItem
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
internal_decoder gb =
   (Struct.ServerReply.AddCharactersDataSetItem
      (BattleCharacters.Struct.DataSetItem.GlyphBoard gb)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.map
      (internal_decoder)
      (BattleCharacters.Struct.GlyphBoard.decoder)
   )
