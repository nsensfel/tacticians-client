module BattleCharacters.Comm.AddSkill exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.DataSetItem
import BattleCharacters.Struct.Skill

-- Local Module ----------------------------------------------------------------
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : BattleCharacters.Struct.Skill.Type -> Struct.ServerReply.Type
internal_decoder sk =
   (Struct.ServerReply.AddCharactersDataSetItem
      (BattleCharacters.Struct.DataSetItem.Skill sk)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.map
      (internal_decoder)
      (BattleCharacters.Struct.Skill.decoder)
   )
