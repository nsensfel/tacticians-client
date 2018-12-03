module Struct.UI exposing
   (
      Type,
      Action(..),
      Tab(..),
      default,
      -- Tab
      get_current_tab,
      set_current_tab,
      reset_current_tab,
      to_string,
      -- Action
      get_action,
      set_action
   )

-- Main Menu -------------------------------------------------------------------
import Struct.InvasionRequest

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Tab =
   DefaultTab
   | NewInvasionTab

type Action =
   None
   | NewInvasion Struct.InvasionRequest.Type

type alias Type =
   {
      current_tab : Tab,
      action : Action
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
default : Type
default =
   {
      current_tab = DefaultTab,
      action = None
   }

-- Tab -------------------------------------------------------------------------
get_current_tab : Type -> Tab
get_current_tab ui =
   case ui.action of
      None -> ui.current_tab
      (NewInvasion _) -> NewInvasionTab

set_current_tab : Tab -> Type -> Type
set_current_tab tab ui = {ui | current_tab = tab}

reset_current_tab : Type -> Type
reset_current_tab ui = {ui | current_tab = DefaultTab}

to_string : Tab -> String
to_string tab =
   case tab of
      DefaultTab -> "Main Menu"
      NewInvasionTab -> "New Invasion"

get_action : Type -> Action
get_action ui = ui.action

set_action : Action -> Type -> Type
set_action action ui = {ui | action = action}
