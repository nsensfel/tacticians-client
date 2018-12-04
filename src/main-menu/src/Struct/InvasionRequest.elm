module Struct.InvasionRequest exposing
   (
      Type,
      Size(..),
      new,
      get_ix,
      get_category,
      get_size,
      get_map_id,
      set_category,
      set_size,
      set_map_id,
      get_url_params
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
      category : Struct.BattleSummary.InvasionCategory,
      size : (Maybe Size),
      map_id : String
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Int -> Type
new ix =
   {
      ix = ix,
      category = (Struct.BattleSummary.get_invasion_category ix),
      size = Nothing,
      map_id = ""
   }

get_ix : Type -> Int
get_ix ir = ir.ix

get_category : Type -> Struct.BattleSummary.InvasionCategory
get_category ir = ir.category

set_category : Struct.BattleSummary.InvasionCategory -> Type -> Type
set_category cat ir = {ir | category = cat}

get_size : Type -> (Maybe Size)
get_size ir = ir.size

set_size : Size -> Type -> Type
set_size s ir = {ir | size = (Just s)}

get_map_id : Type -> String
get_map_id ir = ir.map_id

set_map_id : String -> Type -> Type
set_map_id id ir = {ir | map_id = id}

get_url_params : Type -> (Maybe String)
get_url_params ir =
   case (ir.category, ir.size) of
      (Struct.BattleSummary.InvasionEither, _) -> Nothing
      (_, Nothing) -> Nothing
      (Struct.BattleSummary.InvasionAttack, (Just size)) ->
         (Just
            (
               "?m=a&ix="
               ++ (toString ir.ix)
               ++ "&s="
               ++
               (
                  case size of
                     Small -> "s"
                     Medium -> "m"
                     Large -> "l"
               )
            )
         )

      (Struct.BattleSummary.InvasionDefend, (Just size)) ->
         if (ir.map_id == "")
         then Nothing
         else
            (Just
               (
                  "?m=a&ix="
                  ++ (toString ir.ix)
                  ++ "&map_id="
                  ++ ir.map_id
                  ++ "&s="
                  ++
                  (
                     case size of
                        Small -> "s"
                        Medium -> "m"
                        Large -> "l"
                  )
               )
            )
