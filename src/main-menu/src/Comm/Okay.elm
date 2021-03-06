module Comm.Okay exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battlemap -------------------------------------------------------------------
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
decode : (Json.Decode.Decoder Struct.ServerReply.Type)
decode = (Json.Decode.succeed Struct.ServerReply.Okay)
