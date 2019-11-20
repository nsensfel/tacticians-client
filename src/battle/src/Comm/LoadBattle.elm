module Comm.LoadBattle exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Shared ----------------------------------------------------------------------
import Struct.Flags

-- Local Module ----------------------------------------------------------------
import Comm.Send

import Constants.IO

import Struct.Battle
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
            (
               "stk",
               (Json.Encode.string
                  (Struct.Flags.get_session_token model.flags)
               )
            ),
            (
               "pid",
               (Json.Encode.string
                  (Struct.Flags.get_user_id model.flags)
               )
            ),
            (
               "bid",
               (Json.Encode.string
                  (Struct.Battle.get_id model.battle)
               )
            )
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
