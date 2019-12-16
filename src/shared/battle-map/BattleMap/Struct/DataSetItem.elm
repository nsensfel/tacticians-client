module BattleMap.Struct.DataSetItem exposing (Type(..), add_to)

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.DataSet
import BattleMap.Struct.Tile

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   Tile BattleMap.Struct.Tile.Type

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
add_to : (
      Type ->
      BattleMap.Struct.DataSet.Type ->
      BattleMap.Struct.DataSet.Type
   )
add_to item dataset =
   case item of
      (Tile tl) -> (BattleMap.Struct.DataSet.add_tile tl dataset)