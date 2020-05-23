module Comm.LoadBattle exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Shared ----------------------------------------------------------------------
import Shared.Struct.Flags

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
maybe_encode : Struct.Model.Type -> (Maybe Json.Encode.Value)
maybe_encode model =
   (Just
      (Json.Encode.object
         [
            (
               "stk",
               (Json.Encode.string
                  (Shared.Struct.Flags.get_session_token model.flags)
               )
            ),
            (
               "pid",
               (Json.Encode.string
                  (Shared.Struct.Flags.get_user_id model.flags)
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
   (Comm.Send.maybe_send
      model
      Constants.IO.map_loading_handler
      maybe_encode
   )
