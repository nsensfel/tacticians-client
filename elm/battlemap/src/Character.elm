module Character exposing (Type, Ref, get_ref)

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
