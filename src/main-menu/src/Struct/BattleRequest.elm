module Struct.BattleRequest exposing
   (
      Type,
      Size(..),
      new,
      get_ix,
      get_mode,
      get_category,
      get_size,
      get_map_id,
      set_mode,
      set_category,
      set_size,
      set_map_id,
      get_url_parameters
   )

-- Elm -------------------------------------------------------------------------

-- Main Menu -------------------------------------------------------------------
import Struct.BattleSummary

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Size =
   Small
   | Medium
   | Large

type alias Type =
   {
      ix : Int,
      mode : Struct.BattleSummary.Mode,
      category : Struct.BattleSummary.Category,
      size : (Maybe Size),
      map_id : String
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> Struct.BattleSummary.Category -> Type
new ix category=
   {
      ix = ix,
      mode = Struct.BattleSummary.Either,
      category = category,
      size = Nothing,
      map_id = ""
   }

get_ix : Type -> Int
get_ix ir = ir.ix

get_mode : Type -> Struct.BattleSummary.Mode
get_mode ir = ir.mode

get_category : Type -> Struct.BattleSummary.Category
get_category ir = ir.category

set_mode : Struct.BattleSummary.Mode -> Type -> Type
set_mode mode ir = {ir | mode = mode}

set_category : Struct.BattleSummary.Category -> Type -> Type
set_category category ir = {ir | category = category}

get_size : Type -> (Maybe Size)
get_size ir = ir.size

set_size : Size -> Type -> Type
set_size s ir = {ir | size = (Just s)}

get_map_id : Type -> String
get_map_id ir = ir.map_id

set_map_id : String -> Type -> Type
set_map_id id ir = {ir | map_id = id}

get_url_parameters : Type -> String
get_url_parameters ir =
   (
      "?six="
      ++ (String.fromInt ir.ix)
      ++ "&cat="
      ++
      (
         case ir.category of
            Struct.BattleSummary.Invasion -> "i"
            Struct.BattleSummary.Event -> "e"
            Struct.BattleSummary.Campaign -> "c"
      )
      ++ "&mod="
      ++
      (
         case ir.mode of
            Struct.BattleSummary.Either -> "e"
            Struct.BattleSummary.Attack -> "a"
            Struct.BattleSummary.Defend -> "d"
      )
      ++ "&s="
      ++
      (
         case ir.size of
            (Just Medium) -> "m"
            (Just Large) -> "l"
            _ -> "s"
      )
      ++ "&map_id="
      ++ ir.map_id
   )
