module Battlemap.Tile exposing
   (
      Type,
      set_character,
      get_character,
      get_cost
   )

import Battlemap.Location

import Character

type alias Type =
   {
      location : Battlemap.Location.Ref,
      floor_level : Int,
      char_level : (Maybe Character.Ref)
   }

set_character : (Maybe Character.Ref) -> Type -> Type
set_character char_ref tile = {tile | char_level = char_ref}

get_character : Type -> (Maybe Character.Ref)
get_character tile = tile.char_level

get_cost : Type -> Int
get_cost tile = tile.floor_level
