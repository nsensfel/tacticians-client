module Battlemap.Tile exposing
   (
      Type,
      TileModifier(..),
      set_direction,
      set_navigation,
      reset_tile
   )

import Battlemap.Direction
import Character

type TileModifier =
   CanBeReached
   | CanBeAttacked

type alias Type =
   {
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

set_navigation : Battlemap.Direction.Type -> Type -> Type
set_navigation dir t =
   {t |
      nav_level = dir
   }

reset_tile : Type -> Type
reset_tile t =
   {t |
      nav_level = Battlemap.Direction.None,
      mod_level = Nothing
   }
