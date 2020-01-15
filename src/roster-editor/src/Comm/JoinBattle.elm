module Comm.JoinBattle exposing (try)

-- Elm -------------------------------------------------------------------------
import Array

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
   (Comm.Send.maybe_send
      model
      Constants.IO.join_battle_handler
      maybe_encod
   )
