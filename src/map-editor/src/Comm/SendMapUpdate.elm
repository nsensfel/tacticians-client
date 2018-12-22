module Comm.SendMapUpdate exposing (try)

-- Elm -------------------------------------------------------------------------
import Array

import Json.Encode

-- Map -------------------------------------------------------------------
import Constants.IO

import Comm.Send

import Struct.Event
import Struct.Map
import Struct.Model
import Struct.Tile

--------------------------------------------------------------------------------
-- TYPES ------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
encode_tile_border_values : Struct.Tile.Border -> (List String)
encode_tile_border_values border =
   [
      (Struct.Tile.get_border_type_id border),
      (Struct.Tile.get_border_variant_id border)
   ]

encode_tile_instance : Struct.Tile.Instance -> Json.Encode.Value
encode_tile_instance tile_inst =
   (Json.Encode.list
      (Json.Encode.string)
      (
         [
            (Struct.Tile.get_type_id tile_inst),
            (Struct.Tile.get_variant_id tile_inst)
         ]
         ++
         (List.concatMap
            (encode_tile_border_values)
            (Struct.Tile.get_borders tile_inst)
         )
      )
   )

encode_map : Struct.Model.Type -> (Maybe Json.Encode.Value)
encode_map model =
   (Just
      (Json.Encode.object
         [
            ("stk", (Json.Encode.string model.session_token)),
            ("pid", (Json.Encode.string model.player_id)),
            ("mid", (Json.Encode.string model.map_id)),
            ("w", (Json.Encode.int (Struct.Map.get_width model.map))),
            ("h", (Json.Encode.int (Struct.Map.get_height model.map))),
            (
               "t",
               (Json.Encode.list
                  (encode_tile_instance)
                  (Array.toList (Struct.Map.get_tiles model.map))
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
