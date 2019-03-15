module Struct.UI exposing
   (
      Type,
      Tab(..),
      Action(..),
      default,
      -- Zoom
      get_zoom_level,
      reset_zoom_level,
      mod_zoom_level,
      -- Tab
      try_getting_displayed_tab,
      set_displayed_tab,
      reset_displayed_tab,
      to_string,
      get_all_tabs,
      -- Previous Action
      get_previous_action,
      set_previous_action
   )

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Tab =
   StatusTab
   | TilesTab
   | SettingsTab
   | MarkersTab 

type Action =
   SelectedLocation BattleMap.Struct.Location.Ref

type alias Type =
   {
      zoom_level : Float,
      displayed_tab : (Maybe Tab),
      previous_action : (Maybe Action)
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
      zoom_level = 1.0,
      displayed_tab = (Just TilesTab),
      previous_action = Nothing
   }

-- Zoom ------------------------------------------------------------------------
get_zoom_level : Type -> Float
get_zoom_level ui = ui.zoom_level

reset_zoom_level : Type -> Type
reset_zoom_level ui = {ui | zoom_level = 1.0}

mod_zoom_level : Float -> Type -> Type
mod_zoom_level mod ui = {ui | zoom_level = (mod * ui.zoom_level)}

-- Tab -------------------------------------------------------------------------
try_getting_displayed_tab : Type -> (Maybe Tab)
try_getting_displayed_tab ui = ui.displayed_tab

set_displayed_tab : Tab -> Type -> Type
set_displayed_tab tab ui = {ui | displayed_tab = (Just tab)}

reset_displayed_tab : Type -> Type
reset_displayed_tab ui = {ui | displayed_tab = Nothing}

to_string : Tab -> String
to_string tab =
   case tab of
      StatusTab -> "Status"
      TilesTab -> "Tiles"
      MarkersTab -> "Markers"
      SettingsTab -> "Settings"

get_all_tabs : (List Tab)
get_all_tabs =
   [StatusTab, TilesTab, MarkersTab, SettingsTab]

-- Previous Action -------------------------------------------------------------
set_previous_action : (Maybe Action) -> Type -> Type
set_previous_action act ui = {ui | previous_action = act}

get_previous_action : Type -> (Maybe Action)
get_previous_action ui = ui.previous_action
