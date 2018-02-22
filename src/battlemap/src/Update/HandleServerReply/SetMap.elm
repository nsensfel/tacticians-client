module Update.HandleServerReply.SetMap exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Data.Tiles

import Struct.Battlemap
import Struct.Model
import Struct.Tile

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias MapData =
   {
      width : Int,
      height : Int,
      content : (List Int)
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> String -> Struct.Model.Type
apply_to model serialized_map =
   case
      (Json.Decode.decodeString
         (Json.Decode.map3 MapData
            (Json.Decode.field "width" Json.Decode.int)
            (Json.Decode.field "height" Json.Decode.int)
            (Json.Decode.field
               "content"
               (Json.Decode.list Json.Decode.int)
            )
         )
         serialized_map
      )
   of
      (Result.Ok map_data) ->
         (Struct.Model.reset
            {model |
               battlemap =
                  (Struct.Battlemap.new
                     map_data.width
                     map_data.height
                     (List.indexedMap
                        (deserialize_tile map_data.width)
                        map_data.content
                     )
                  )
            }
            (Dict.empty)
         )

      _ -> model
