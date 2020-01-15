module Comm.LoadRoster exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Shared ----------------------------------------------------------------------
import Struct.Flags

-- Local Module ----------------------------------------------------------------
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
            ("stk",
               (Json.Encode.string
                  (Struct.Flags.get_session_token model.flags)
               )
            ),
            ("pid",
               (Json.Encode.string
                  (Struct.Flags.get_user_id model.flags)
               )
            ),
            ("rid", (Json.Encode.string model.roster_id))
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
      Constants.IO.roster_loading_handler
      maybe_encode
   )
