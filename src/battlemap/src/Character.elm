module Character exposing
   (
      Type,
      Ref,
      new,
      get_ref,
      get_team,
      get_icon_id,
      get_portrait_id,
      get_current_health,
      get_max_health,
      get_location,
      set_location,
      get_movement_points,
      get_attack_range,
      is_enabled,
      set_enabled
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
      health : Int,
      max_health : Int,
      team : Int,
      movement_points : Int,
      atk_dist : Int,
      enabled : Bool
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
      Int -> -- health
      Int -> -- max_health
      Battlemap.Location.Type -> -- location
      Int -> -- team
      Int -> -- movement_points
      Int -> -- atk_dist
      Bool -> -- enabled
      Type
   )
new
   id name icon portrait
   health max_health
   location
   team movement_points atk_dist
   enabled =
   {
      id = id,
      name = name,
      icon = icon,
      portrait = portrait,
      health = health,
      max_health = max_health,
      location = location,
      team = team,
      movement_points = movement_points,
      atk_dist = atk_dist,
      enabled = enabled
   }

get_ref : Type -> Ref
get_ref c = c.id

get_team : Type -> Int
get_team c = c.team

get_icon_id : Type -> String
get_icon_id c = c.icon

get_portrait_id : Type -> String
get_portrait_id c = c.portrait

get_current_health : Type -> Int
get_current_health c = c.health

get_max_health : Type -> Int
get_max_health c = c.max_health

get_location : Type -> Battlemap.Location.Type
get_location t = t.location

set_location : Battlemap.Location.Type -> Type -> Type
set_location location char = {char | location = location}

get_movement_points : Type -> Int
get_movement_points char = char.movement_points

get_attack_range : Type -> Int
get_attack_range char = char.atk_dist

is_enabled : Type -> Bool
is_enabled char = char.enabled

set_enabled : Type -> Bool -> Type
set_enabled char enabled = {char | enabled = enabled}
