module Comm.SetInventory exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Map -------------------------------------------------------------------
import Struct.Inventory
import Struct.ServerReply

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
internal_decoder : Struct.Inventory.Type -> Struct.ServerReply.Type
internal_decoder inv = (Struct.ServerReply.SetInventory inv)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode = (Json.Decode.map (internal_decoder) (Struct.Inventory.decoder))
