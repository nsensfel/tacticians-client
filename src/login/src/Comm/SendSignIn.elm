module Comm.SendSignIn exposing (try)

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
            ("usr", (Json.Encode.string model.username)),
            ("pwd", (Json.Encode.string model.password1))
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
      Constants.IO.login_sign_in_handler
      try_encoding
   )
