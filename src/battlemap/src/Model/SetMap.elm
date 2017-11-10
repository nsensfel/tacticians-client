module Model.SetMap exposing (apply_to)
import Array
import Json.Decode



import Battlemap.Tile

import Model

type alias MapData =
   {
      width : Int,
      height : Int,
      content : (List (List Int))
   }

from_int : Int -> Int -> (List Int) -> Battlemap.Tile.Type
from_int map_width index data =
   case data of
      [icon_id, cost] ->
         {
            location =
               {
                  x = (index % map_width),
                  y = (index // map_width)
               },
            icon_id = (toString icon_id),
            crossing_cost = cost
         }
      _ ->
         {
            location =
               {
                  x = (index % map_width),
                  y = (index // map_width)
               },
            icon_id = "0",
            crossing_cost = 1
         }

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
         {model |
            battlemap =
               {
                  width = map_data.width,
                  height = map_data.height,
                  content =
                     (Array.fromList
                        (List.indexedMap
                           (from_int map_data.width)
                           map_data.content
                        )
                     ),
                  navigator = Nothing
               }
         }

      _ -> model
