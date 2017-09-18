module Battlemap exposing
   (
      Battlemap,
      random,
      apply_to_tile,
      apply_to_tile_unsafe,
      has_location,
      apply_to_all_tiles
   )

import Array exposing (Array, set, get, map)

import Battlemap.Tile exposing (Tile, generate)
import Battlemap.Direction exposing (Direction(..))
import Battlemap.Location exposing (Location)

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

has_location : Battlemap -> Location -> Bool
has_location bmap loc =
   (
      (loc.x >= 0)
      && (loc.y >= 0)
      && (loc.x < bmap.width)
      && (loc.y < bmap.height)
   )

apply_to_all_tiles : Battlemap -> (Tile -> Tile) -> Battlemap
apply_to_all_tiles bmap fun =
   {bmap |
      content = (map fun bmap.content)
   }

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

apply_to_tile_unsafe : Battlemap -> Location -> (Tile -> Tile) -> Battlemap
apply_to_tile_unsafe bmap loc fun =
   let
      index = (location_to_index bmap loc)
      at_index = (get index bmap.content)
   in
      case at_index of
         Nothing -> bmap
         (Just tile) ->
            {bmap |
               content =
                  (set
                     index
                     (fun tile)
                     bmap.content
                  )
            }
