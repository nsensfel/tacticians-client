module Struct.Puppeteer exposing
   (
      Type,
      new,
      append_forward,
      append_backward,
      forward,
      backward,
      step,
      get_is_playing_forward,
      set_is_playing_forward,
      maybe_get_current_action
   )

-- Elm -------------------------------------------------------------------------
import List

-- Shared ----------------------------------------------------------------------
import Util.List

-- Local Module ----------------------------------------------------------------
import Struct.TurnResult
import Struct.PuppeteerAction

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      forward_actions : (List Struct.PuppeteerAction.Type),
      backward_actions : (List Struct.PuppeteerAction.Type),
      is_playing_forward : Bool
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
      forward_actions = [],
      backward_actions = [],
      is_playing_forward = True
   }

append_forward : (List Struct.PuppeteerAction.Type) -> Type -> Type
append_forward actions puppeteer =
   {puppeteer |
      forward_actions = (List.concat puppeteer.forward_actions actions)
   }

append_backward : (List Struct.PuppeteerAction.Type) -> Type -> Type
append_backward actions puppeteer =
   {puppeteer |
      backward_actions = (List.concat actions puppeteer.backward_actions)
   }

forward : Type -> Type
forward puppeteer =
   case (Util.List.pop puppeteer.forward_actions) of
      ([], Nothing) -> puppeteer
      (forward_actions, (Just action)) ->
         {puppeteer |
            forward_actions = forward_actions,
            backward_actions = [action|puppeteer.backward_actions],
            is_playing_forward = true
         }

backward : Type -> Type
backward puppeteer =
   case (Util.List.pop puppeteer.backward_actions) of
      ([], Nothing) -> puppeteer
      (backward_actions, (Just action)) ->
         {puppeteer |
            forward_actions = [action|forward_actions],
            backward_actions = backward_actions,
            is_playing_forward = false
         }

step : Type -> Type
step puppeteer =
   if (puppeteer.is_playing_forward)
   then (forward puppeteer)
   else (backward puppeteer)

get_is_playing_forward : Type -> Bool
get_is_playing_forward puppeteer = puppeteer.is_playing_forward

set_is_playing_forward : Bool -> Type -> Type
set_is_playing_forward val puppeteer = {puppeteer | is_playing_forward = val}

maybe_get_current_action : Type -> (Maybe (Struct.PuppeteerAction.Type))
maybe_get_current_action puppeteer =
   if (puppeteer.is_playing_forward)
   then (List.head puppeteer.forward_actions)
   else (List.head puppeteer.backward_actions)
