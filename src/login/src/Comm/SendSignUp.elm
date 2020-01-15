module Comm.SendSignUp exposing (try)

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
maybe_encode : Struct.Model.Type -> (Maybe Json.Encode.Value)
maybe_encode model =
   (Just
      (Json.Encode.object
         [
            ("usr", (Json.Encode.string model.username)),
            ("pwd", (Json.Encode.string model.password1)),
            ("eml", (Json.Encode.string model.email1))
         ]
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try : Struct.Model.Type -> (Maybe (Cmd Struct.Event.Type))
try model =
   (Comm.Send.maybe_send
      model
      Constants.IO.login_sign_up_handler
      maybe_encode
   )
