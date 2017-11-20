module Model.HandleServerReply.SetMap exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array
import Dict
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Tile

import Data.Tile

import Model

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
deserialize_tile : Int -> Int -> Int -> Battlemap.Tile.Type
deserialize_tile map_width index id =
   (Battlemap.Tile.new
      (index % map_width)
      (index // map_width)
      (Data.Tile.get_icon id)
      (Data.Tile.get_cost id)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Model.Type -> String -> Model.Type
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
         (Model.reset
            {model |
               battlemap =
                  (Battlemap.new
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
