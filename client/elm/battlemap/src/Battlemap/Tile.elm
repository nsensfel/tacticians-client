module Battlemap.Tile exposing (Type, set_direction)

import Battlemap.Direction
import Character

type alias Type =
   {
      floor_level : Int,
      nav_level : Battlemap.Direction.Type,
      char_level : (Maybe Character.Ref)
--    mod_level : (Set TileModifier)
   }

set_direction : Battlemap.Direction.Type -> Type -> Type
set_direction d t =
   {t |
      nav_level = d
   }
