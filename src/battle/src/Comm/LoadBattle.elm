module Comm.LoadBattle exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Map -------------------------------------------------------------------
import Comm.Send

import Constants.IO

import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
try_encoding : Struct.Model.Type -> (Maybe Json.Encode.Value)
try_encoding model =
   (Just
      (Json.Encode.object
         [
            ("stk", (Json.Encode.string model.session_token)),
            ("pid", (Json.Encode.string model.player_id)),
            ("bid", (Json.Encode.string model.battle_id))
         ]
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try : Struct.Model.Type -> (Maybe (Cmd Struct.Event.Type))
try model =
   (Comm.Send.try_sending
      model
      Constants.IO.map_loading_handler
      try_encoding
   )
