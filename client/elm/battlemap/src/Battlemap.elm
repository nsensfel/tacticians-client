module Battlemap exposing
   (
      Type,
      apply_to_tile,
      apply_to_tile_unsafe,
      has_location,
      apply_to_all_tiles
   )

import Array

import Battlemap.Tile
import Battlemap.Direction
import Battlemap.Location

type alias Type =
   {
      width : Int,
      height : Int,
      content : (Array.Array Battlemap.Tile.Type)
   }

location_to_index : Type -> Battlemap.Location.Type -> Int
location_to_index bmap loc =
   ((loc.y * bmap.width) + loc.x)

has_location : Type -> Battlemap.Location.Type -> Bool
has_location bmap loc =
   (
      (loc.x >= 0)
      && (loc.y >= 0)
      && (loc.x < bmap.width)
      && (loc.y < bmap.height)
   )

apply_to_all_tiles : (
      Type -> (Battlemap.Tile.Type -> Battlemap.Tile.Type) -> Type
   )
apply_to_all_tiles bmap fun =
   {bmap |
      content = (Array.map fun bmap.content)
   }

apply_to_tile : (
      Type ->
      Battlemap.Location.Type ->
      (Battlemap.Tile.Type -> Battlemap.Tile.Type) ->
      (Maybe Type)
   )
apply_to_tile bmap loc fun =
   let
      index = (location_to_index bmap loc)
      at_index = (Array.get index bmap.content)
   in
      case at_index of
         Nothing ->
            Nothing
         (Just tile) ->
            (Just
               {bmap |
                  content =
                     (Array.set
                        index
                        (fun tile)
                        bmap.content
                     )
               }
            )

apply_to_tile_unsafe : (
      Type ->
      Battlemap.Location.Type ->
      (Battlemap.Tile.Type -> Battlemap.Tile.Type) ->
      Type
   )
apply_to_tile_unsafe bmap loc fun =
   let
      index = (location_to_index bmap loc)
      at_index = (Array.get index bmap.content)
   in
      case at_index of
         Nothing -> bmap
         (Just tile) ->
            {bmap |
               content =
                  (Array.set
                     index
                     (fun tile)
                     bmap.content
                  )
            }
