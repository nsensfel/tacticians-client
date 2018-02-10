module Struct.Character exposing
   (
      Type,
      Ref,
      new,
      get_ref,
      get_team,
      get_icon_id,
      get_portrait_id,
      get_current_health,
      get_location,
      set_location,
      get_attributes,
      get_statistics,
      is_enabled,
      set_enabled
   )

-- Battlemap -------------------------------------------------------------------
import Struct.Attributes
import Struct.Location
import Struct.Statistics
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      id : String,
      name : String,
      icon : String,
      portrait : String,
      location : Struct.Location.Type,
      health : Int,
      team : Int,
      enabled : Bool,
      attributes : Struct.Attributes.Type,
      statistics : Struct.Statistics.Type,
      weapons : Struct.WeaponSet.Type
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
      Struct.Location.Type -> -- location
      Int -> -- health
      Int -> -- team
      Bool -> -- enabled
      Struct.Attributes.Type ->
      Struct.WeaponSet.Type ->
      Type
   )
new
   id name icon portrait
   location health
   team enabled
   attributes weapons =
   {
      id = id,
      name = name,
      icon = icon,
      portrait = portrait,
      location = location,
      health = health,
      attributes = attributes,
      statistics =
         (Struct.Statistics.new
            attributes
            weapons
         ),
      team = team,
      enabled = enabled,
      weapons = weapons
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

get_location : Type -> Struct.Location.Type
get_location t = t.location

set_location : Struct.Location.Type -> Type -> Type
set_location location char = {char | location = location}

get_attributes : Type -> Struct.Attributes.Type
get_attributes char = char.attributes

get_statistics : Type -> Struct.Statistics.Type
get_statistics char = char.statistics

is_enabled : Type -> Bool
is_enabled char = char.enabled

set_enabled : Type -> Bool -> Type
set_enabled char enabled = {char | enabled = enabled}
