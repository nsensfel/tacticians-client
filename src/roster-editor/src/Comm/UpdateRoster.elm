module Comm.UpdateRoster exposing (try)

-- Elm -------------------------------------------------------------------------
import Array

import List

import Json.Encode

-- Roster Editor ---------------------------------------------------------------
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
try_encoding : Struct.Model.Type -> (Maybe Json.Encode.Value)
try_encoding model =
   (Just
      (Json.Encode.list
         (List.map
            (Struct.Character.encode)
            (List.filter
               (Struct.Character.get_was_edited)
               (Array.toList model.characters)
            )
         )
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try : Struct.Model.Type -> (Maybe (Cmd Struct.Event.Type))
try model =
   (Comm.Send.try_sending
      model
      Constants.IO.roster_update_handler
      try_encoding
   )
