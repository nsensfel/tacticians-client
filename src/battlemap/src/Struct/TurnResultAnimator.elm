module Struct.TurnResultAnimator exposing
   (
      Type,
      maybe_new,
      maybe_trigger_next_step,
      get_current_action
   )

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.TurnResult

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      remaining_actions : (List Struct.TurnResult.Type),
      current_action : Struct.TurnResult.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
maybe_new : (List Struct.TurnResult.Type) -> (Maybe Type)
maybe_new turn_results =
   case ((List.head turn_results), (List.tail turn_results)) of
      ((Just head), (Just tail)) ->
         (Just
            {
               remaining_actions = tail,
               current_action = head
            }
         )

      (_, _) -> Nothing

maybe_trigger_next_step : Type -> (Maybe Type)
maybe_trigger_next_step tra =
   case (Struct.TurnResult.maybe_remove_step tra.current_action) of
      (Just updated_action) -> (Just {tra | current_action = updated_action})
      Nothing -> (maybe_new tra.remaining_actions)

get_current_action : Type -> Struct.TurnResult.Type
get_current_action tra = tra.current_action
