module Send.LoadBattlemap exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Battlemap -------------------------------------------------------------------
import Struct.Model
import Struct.Event

import Constants.IO

import Send

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
try : Model.Type -> (Maybe (Cmd Event.Type))
try model =
   (Send.try_sending model Constants.IO.battlemap_loading_handler try_encoding)
