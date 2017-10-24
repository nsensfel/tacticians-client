module Character exposing
   (
      Type,
      Ref,
      get_ref,
      get_team,
      get_icon_id,
      get_location,
      set_location,
      get_movement_points,
      get_attack_range
   )

import Battlemap.Location

type alias Type =
   {
      id : String,
      name : String,
      icon : String,
      portrait : String,
      location : Battlemap.Location.Type,
      team : Int,
      movement_points : Int,
      atk_dist : Int
   }

type alias Ref = String

get_ref : Type -> Ref
get_ref c = c.id

get_team : Type -> Int
get_team c = c.team

get_icon_id : Type -> String
get_icon_id c = c.icon

get_location : Type -> Battlemap.Location.Type
get_location t = t.location

set_location : Battlemap.Location.Type -> Type -> Type
set_location location char = {char | location = location}

get_movement_points : Type -> Int
get_movement_points char = char.movement_points

get_attack_range : Type -> Int
get_attack_range char = char.atk_dist
