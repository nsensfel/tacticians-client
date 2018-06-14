module Struct.Tile exposing
   (
      Type,
      new,
      error_tile,
      get_location,
      get_icon_id,
      get_cost
   )

-- Battlemap -------------------------------------------------------------------
import Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      location : Struct.Location.Type,
      icon_id : String,
      crossing_cost : Int
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> Int -> String -> Int -> Type
new x y icon_id crossing_cost =
   {
      location = {x = x, y = y},
      icon_id = icon_id,
      crossing_cost = crossing_cost
   }

error_tile : Int -> Int -> Type
error_tile x y =
   {
      location = {x = x, y = y},
      icon_id = "error",
      crossing_cost = 1
   }

get_location : Type -> Struct.Location.Type
get_location tile = tile.location

get_icon_id : Type -> String
get_icon_id tile =
   -- Just to see how it looks with SVG
   (toString (rem tile.crossing_cost 4))

get_cost : Type -> Int
get_cost tile = tile.crossing_cost
