module Comm.JoinBattle exposing (try)

-- Elm -------------------------------------------------------------------------
import Array

import Json.Encode

-- Shared ----------------------------------------------------------------------
import Shared.Struct.Flags

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
                  (Shared.Struct.Flags.get_session_token model.flags)
               )
            ),
            ("pid",
               (Json.Encode.string
                  (Shared.Struct.Flags.get_user_id model.flags)
               )
            ),
            (
               "six",
               (Json.Encode.int
                  (
                     case
                        (String.toInt
                           (Shared.Struct.Flags.force_get_parameter "six" model.flags)
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
                  (Shared.Struct.Flags.force_get_parameter "cat" model.flags)
               )
            ),
            (
               "mod",
               (Json.Encode.string
                  (Shared.Struct.Flags.force_get_parameter "mod" model.flags)
               )
            ),
            (
               "s",
               (Json.Encode.string
                  (Shared.Struct.Flags.force_get_parameter "s" model.flags)
               )
            ),
            (
               "map_id",
               (Json.Encode.string
                  (Shared.Struct.Flags.force_get_parameter "map_id" model.flags)
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
      maybe_encode
   )
