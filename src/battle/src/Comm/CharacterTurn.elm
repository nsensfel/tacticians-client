module Comm.CharacterTurn exposing (try)

-- Elm -------------------------------------------------------------------------
import Json.Encode

-- Shared ----------------------------------------------------------------------
import Struct.Flags

-- Local Module ----------------------------------------------------------------
import Constants.IO

import Comm.Send

import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
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
   case (Struct.CharacterTurn.try_getting_active_character model.char_turn) of
      (Just char) ->
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
                  ),
                  (
                     "cix",
                     (Json.Encode.int (Struct.Character.get_index char))
                  ),
                  ("act", (Struct.CharacterTurn.encode model.char_turn))
               ]
            )
         )

      _ ->
         Nothing

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
try : Struct.Model.Type -> (Maybe (Cmd Struct.Event.Type))
try model =
   (Comm.Send.try_sending
      model
      Constants.IO.character_turn_handler
      try_encoding
   )
