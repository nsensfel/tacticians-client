module BattleCharacters.Comm.AddArmor exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.DataSetItem

-- Local Module ----------------------------------------------------------------
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : BattleCharacters.Struct.Armor.Type -> Struct.ServerReply.Type
internal_decoder ar =
   (Struct.ServerReply.AddCharactersDataSetItem
      (BattleCharacters.Struct.DataSetItem.Armor ar)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.map
      (internal_decoder)
      (BattleCharacters.Struct.Armor.decoder)
   )
