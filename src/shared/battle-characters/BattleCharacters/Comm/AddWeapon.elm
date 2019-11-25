module BattleCharacters.Comm.AddWeapon exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.DataSetItem
import BattleCharacters.Struct.Weapon

-- Local Module ----------------------------------------------------------------
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : (
      BattleCharacters.Struct.Weapon.Type ->
      Struct.ServerReply.Type
   )
internal_decoder wp =
   (Struct.ServerReply.AddCharactersDataSetItem
      (BattleCharacters.Struct.DataSetItem.Weapon wp)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode =
   (Json.Decode.map
      (internal_decoder)
      (BattleCharacters.Struct.Weapon.decoder)
   )
