module Battlemap.Tile exposing
   (
      Type,
      get_location,
      get_icon_id,
      get_cost
   )

import Battlemap.Location

type alias Type =
   {
      location : Battlemap.Location.Type,
      icon_id : String,
      crossing_cost : Int
   }

get_location : Type -> Battlemap.Location.Type
get_location tile = tile.location

get_icon_id : Type -> String
get_icon_id tile = tile.icon_id

get_cost : Type -> Int
get_cost tile = tile.crossing_cost
