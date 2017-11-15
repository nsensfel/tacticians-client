module Character exposing
   (
      Type,
      Ref,
      new,
      get_ref,
      get_team,
      get_icon_id,
      get_portrait_id,
      get_location,
      set_location,
      get_movement_points,
      get_attack_range
   )

-- Battlemap -------------------------------------------------------------------
import Battlemap.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : (
      String -> -- id
      String -> -- name
      String -> -- icon
      String -> -- portrait
      Battlemap.Location.Type -> -- location
      Int -> -- team
      Int -> -- movement_points
      Int -> -- atk_dist
      Type
   )
new id name icon portrait location team movement_points atk_dist =
   {
      id = id,
      name = name,
      icon = icon,
      portrait = portrait,
      location = location,
      team = team,
      movement_points = movement_points,
      atk_dist = atk_dist
   }

get_ref : Type -> Ref
get_ref c = c.id

get_team : Type -> Int
get_team c = c.team

get_icon_id : Type -> String
get_icon_id c = c.icon

get_portrait_id : Type -> String
get_portrait_id c = c.portrait

get_location : Type -> Battlemap.Location.Type
get_location t = t.location

set_location : Battlemap.Location.Type -> Type -> Type
set_location location char = {char | location = location}

get_movement_points : Type -> Int
get_movement_points char = char.movement_points

get_attack_range : Type -> Int
get_attack_range char = char.atk_dist
