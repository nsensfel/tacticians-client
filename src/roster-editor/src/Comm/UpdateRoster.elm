module Comm.UpdateRoster exposing (try)

-- Elm -------------------------------------------------------------------------
import Array

import List

import Json.Encode

-- Shared ----------------------------------------------------------------------
import Shared.Struct.Flags

-- Local Module ----------------------------------------------------------------
import Comm.Send

import Constants.IO

import Struct.Character
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
                  (Shared.Struct.Flags.get_session_token model.flags)
               )
            ),
            ("pid",
               (Json.Encode.string
                  (Shared.Struct.Flags.get_user_id model.flags)
               )
            ),
            (
               "rst",
               (Json.Encode.list
                  (
                     (Struct.Character.to_unresolved)
                     >> (Struct.Character.encode)
                  )
                  (List.filter
                     (Struct.Character.get_was_edited)
                     (Array.toList model.characters)
                  )
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
      Constants.IO.roster_update_handler
      maybe_encode
   )
