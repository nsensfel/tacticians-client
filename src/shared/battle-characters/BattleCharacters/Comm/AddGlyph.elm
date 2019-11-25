module BattleCharacters.Comm.AddGlyph exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.DataSetItem
import BattleCharacters.Struct.Glyph

-- Local Module ----------------------------------------------------------------
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : BattleCharacters.Struct.Glyph.Type -> Struct.ServerReply.Type
internal_decoder gl =
   (Struct.ServerReply.AddCharactersDataSetItem
      (BattleCharacters.Struct.DataSetItem.Glyph gl)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.map (internal_decoder) (BattleCharacters.Struct.Glyph.decoder))
