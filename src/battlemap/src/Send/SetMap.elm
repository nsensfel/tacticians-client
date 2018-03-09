module Send.SetMap exposing (decode)

-- Elm -------------------------------------------------------------------------
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Data.Tiles

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
deserialize_tile : Int -> Int -> Int -> Struct.Tile.Type
deserialize_tile map_width index id =
   (Struct.Tile.new
      (index % map_width)
      (index // map_width)
      (Data.Tiles.get_icon id)
      (Data.Tiles.get_cost id)
   )

internal_decoder : MapData -> Struct.ServerReply.Type
internal_decoder map_data =
   (Struct.ServerReply.SetMap
      (Struct.Battlemap.new
         map_data.w
         map_data.h
         (List.indexedMap
            (deserialize_tile map_data.w)
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
