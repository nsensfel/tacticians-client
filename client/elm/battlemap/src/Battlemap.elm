module Battlemap exposing (Battlemap, random, apply_to_tile)

import Array exposing (Array, set, get)

import Battlemap.Tile exposing (Tile, generate)
import Battlemap.Direction exposing (..)
import Battlemap.Location exposing (..)

type alias Battlemap =
   {
      width : Int,
      height : Int,
      content : (Array Tile)
   }

random : Battlemap
random =
   {
      width = 6,
      height = 6,
      content = (generate 6 6)
   }

location_to_index : Battlemap -> Location -> Int
location_to_index bmap loc =
   ((loc.y * bmap.width) + loc.x)

apply_to_tile : Battlemap -> Location -> (Tile -> Tile) -> (Maybe Battlemap)
apply_to_tile bmap loc fun =
   let
      index = (location_to_index bmap loc)
      at_index = (get index bmap.content)
   in
      case at_index of
         Nothing ->
            Nothing
         (Just tile) ->
            (Just
               {bmap |
                  content =
                     (set
                        index
                        (fun tile)
                        bmap.content
                     )
               }
            )
