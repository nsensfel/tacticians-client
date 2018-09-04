module Comm.LoadPlayer exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- MainMenu --------------------------------------------------------------------
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
   let
      player_id = (Json.Encode.string model.player_id)
   in
      (Just
         (Json.Encode.object
            [
               ("stk", (Json.Encode.string model.session_token)),
               ("pid", player_id),
               ("id", player_id)
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
      Constants.IO.player_loading_handler
      try_encoding
   )
