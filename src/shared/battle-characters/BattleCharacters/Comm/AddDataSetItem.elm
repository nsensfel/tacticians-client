module BattleCharacters.Comm.AddDataSetItem exposing (prefix, get_decoder_for)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Comm.AddArmor
import BattleCharacters.Comm.AddGlyph
import BattleCharacters.Comm.AddGlyphBoard
import BattleCharacters.Comm.AddPortrait
import BattleCharacters.Comm.AddSkill
import BattleCharacters.Comm.AddWeapon

-- Local Module ----------------------------------------------------------------
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
prefix : String
prefix = "acds"

get_decoder_for : String -> (Json.Decode.Decoder Struct.ServerReply.Type)
get_decoder_for reply_type =
   case reply_type of
      "acds_armor" -> (BattleCharacters.Comm.AddArmor.decode)
      "acds_weapon" -> (BattleCharacters.Comm.AddWeapon.decode)
      "acds_portrait" -> (BattleCharacters.Comm.AddPortrait.decode)
      "acds_glyph" -> (BattleCharacters.Comm.AddGlyph.decode)
      "acds_glyph_board" -> (BattleCharacters.Comm.AddGlyphBoard.decode)
      "acds_skill" -> (BattleCharacters.Comm.AddSkill.decode)

      other ->
         (Json.Decode.fail
            (
               "Unknown server command \""
               ++ other
               ++ "\""
            )
         )
