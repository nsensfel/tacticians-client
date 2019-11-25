module BattleMap.Struct.DataSet exposing
   (
      Type,
      new,
      is_ready,
      get_tile,
      add_tile
   )

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle ----------------------------------------------------------------------
import BattleMap.Struct.Tile

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      tiles : (Dict.Dict BattleMap.Struct.Tile.Ref BattleMap.Struct.Tile.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Type
new =
   {
      tiles = (Dict.empty)
   }

is_ready : Type -> Bool
is_ready data_set =
   (
      (not (Dict.isEmpty data_set.tiles))
   )

---- Accessors -----------------------------------------------------------------

--------------
---- Tile ----
--------------
get_tile : (
      BattleMap.Struct.Tile.Ref ->
      Type ->
      BattleMap.Struct.Tile.Type
   )
get_tile tl_id data_set =
   case (Dict.get tl_id data_set.tiles) of
      (Just tl) -> tl
      Nothing -> BattleMap.Struct.Tile.none

add_tile : BattleMap.Struct.Tile.Type -> Type -> Type
add_tile tl data_set =
   {data_set |
      tiles =
         (Dict.insert
            (BattleMap.Struct.Tile.get_id tl)
            tl
            data_set.tiles
         )
   }
