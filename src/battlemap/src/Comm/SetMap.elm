module Comm.SetMap exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Model
import Struct.ServerReply
import Struct.Tile

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias MapData =
   {
      w : Int,
      h : Int,
      t : (List Int)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
deserialize_tile_instance : Int -> Int -> Int -> Struct.Tile.Instance
deserialize_tile_instance map_width index id =
   (Struct.Tile.new_instance
      (index % map_width)
      (index // map_width)
      (toString id)
      -1
      -1
   )

internal_decoder : MapData -> Struct.ServerReply.Type
internal_decoder map_data =
   (Struct.ServerReply.SetMap
      (Struct.Battlemap.new
         map_data.w
         map_data.h
         (List.indexedMap
            (deserialize_tile_instance map_data.w)
            map_data.t
         )
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
decode : (Struct.Model.Type -> (Json.Decode.Decoder Struct.ServerReply.Type))
decode model =
   (Json.Decode.map
      internal_decoder
      (Json.Decode.map3 MapData
         (Json.Decode.field "w" Json.Decode.int)
         (Json.Decode.field "h" Json.Decode.int)
         (Json.Decode.field
            "t"
            (Json.Decode.list Json.Decode.int)
         )
      )
   )
