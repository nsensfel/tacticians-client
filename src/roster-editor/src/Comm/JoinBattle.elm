module Comm.JoinBattle exposing (try)

-- Elm -------------------------------------------------------------------------
import Array

import Json.Encode

-- Shared ----------------------------------------------------------------------
import Struct.Flags

-- Roster Editor ---------------------------------------------------------------
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
            ("stk", (Json.Encode.string model.session_token)),
            ("pid", (Json.Encode.string model.player_id)),
            (
               "six",
               (Json.Encode.int
                  (
                     case
                        (String.toInt
                           (Struct.Flags.force_get_param "six" model.flags)
                        )
                     of
                        (Just ix) -> ix
                        _ -> -1
                  )
               )
            ),
            (
               "cat",
               (Json.Encode.string
                  (Struct.Flags.force_get_param "cat" model.flags)
               )
            ),
            (
               "mod",
               (Json.Encode.string
                  (Struct.Flags.force_get_param "mod" model.flags)
               )
            ),
            (
               "s",
               (Json.Encode.string
                  (Struct.Flags.force_get_param "s" model.flags)
               )
            ),
            (
               "map_id",
               (Json.Encode.string
                  (Struct.Flags.force_get_param "map_id" model.flags)
               )
            ),
            (
               "r",
               (Json.Encode.array
                  (Json.Encode.int)
                  (Array.filter
                     (\e -> (e /= -1))
                     model.battle_order
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
   (Comm.Send.try_sending
      model
      Constants.IO.join_battle_handler
      try_encoding
   )
