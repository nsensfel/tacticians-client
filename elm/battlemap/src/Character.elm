module Character exposing (Type, Ref, get_ref, get_location)

import Battlemap.Location

type alias Type =
   {
      id : String,
      name : String,
      icon : String,
      portrait : String,
      location : Battlemap.Location.Type,
      movement_points : Int,
      atk_dist : Int
   }

type alias Ref = String

get_ref : Type -> Ref
get_ref c =
   c.id

get_location : Type -> Battlemap.Location.Type
get_location t = t.location
