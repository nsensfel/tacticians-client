module Send.LoadBattlemap exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Constants.IO

import Send.Send

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
            ("session_token", (Json.Encode.string "0")),
            ("player_id", (Json.Encode.string model.player_id)),
            ("battlemap_id", (Json.Encode.string "0")),
            ("instance_id", (Json.Encode.string "0"))
         ]
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try : Struct.Model.Type -> (Maybe (Cmd Struct.Event.Type))
try model =
   (Send.Send.try_sending
      model
      Constants.IO.battlemap_loading_handler
      try_encoding
   )
