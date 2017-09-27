module Battlemap.Tile exposing
   (
      Type,
      TileModifier(..),
      set_direction,
      reset
   )

import Battlemap.Direction
import Battlemap.Location

import Character

type TileModifier =
   CanBeReached
   | CanBeAttacked

type alias Type =
   {
      location : Battlemap.Location.Ref,
      floor_level : Int,
      nav_level : Battlemap.Direction.Type,
      char_level : (Maybe Character.Ref),
      mod_level : (Maybe TileModifier)
   }

set_direction : Battlemap.Direction.Type -> Type -> Type
set_direction d t =
   {t |
      nav_level = d
   }

reset: Type -> Type
reset t =
   {t |
      nav_level = Battlemap.Direction.None,
      mod_level = Nothing
   }
