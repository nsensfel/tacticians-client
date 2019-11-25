module BattleMap.Comm.AddTile exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSetItem
import BattleMap.Struct.Tile

-- Local Module ----------------------------------------------------------------
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : BattleMap.Struct.Tile.Type -> Struct.ServerReply.Type
internal_decoder tl =
   (Struct.ServerReply.AddMapDataSetItem (BattleMap.Struct.DataSetItem.Tile tl))

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode = (Json.Decode.map (internal_decoder) (BattleMap.Struct.Tile.decoder))
