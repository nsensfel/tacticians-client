module Model.HandleServerReply.SetMap exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array
import Dict
import Json.Decode

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Tile

import Model

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias MapData =
   {
      width : Int,
      height : Int,
      content : (List (List Int))
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
deserialize_tile : Int -> Int -> (List Int) -> Battlemap.Tile.Type
deserialize_tile map_width index data =
   case data of
      [icon_id, cost] ->
         (Battlemap.Tile.new
            (index % map_width)
            (index // map_width)
            (toString icon_id)
            cost
         )

      _ ->
         (Battlemap.Tile.error_tile
            (index % map_width)
            (index // map_width)
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
               (Json.Decode.list
                  (Json.Decode.list Json.Decode.int)
               )
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
