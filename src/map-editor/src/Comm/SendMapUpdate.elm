module Comm.SendMapUpdate exposing (try)

-- Elm -------------------------------------------------------------------------
import Array

import Json.Encode

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map
import BattleMap.Struct.TileInstance

-- Local Module ----------------------------------------------------------------
import Constants.IO

import Comm.Send

import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
encode_map : Struct.Model.Type -> (Maybe Json.Encode.Value)
encode_map model =
   (Just
      (Json.Encode.object
         [
            ("stk", (Json.Encode.string model.session_token)),
            ("pid", (Json.Encode.string model.player_id)),
            ("mid", (Json.Encode.string model.map_id)),
            ("w", (Json.Encode.int (BattleMap.Struct.Map.get_width model.map))),
            (
               "h",
               (Json.Encode.int (BattleMap.Struct.Map.get_height model.map))
            ),
            (
               "t",
               (Json.Encode.list
                  (BattleMap.Struct.TileInstance.encode)
                  (Array.toList (BattleMap.Struct.Map.get_tiles model.map))
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
      Constants.IO.map_update_handler
      encode_map
   )
