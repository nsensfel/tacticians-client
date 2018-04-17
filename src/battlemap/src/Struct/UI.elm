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
      -- Manual Controls
      has_manual_controls_enabled,
      -- Previous Action
      has_focus,
      get_previous_action,
      set_previous_action
   )

-- Battlemap -------------------------------------------------------------------
import Struct.Location

import Struct.Character

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Tab =
   StatusTab
   | CharactersTab
   | SettingsTab
   | TimelineTab

type Action =
   UsedManualControls
   | SelectedLocation Struct.Location.Ref
   | SelectedCharacter Struct.Character.Ref
   | AttackedCharacter Struct.Character.Ref

type alias Type =
   {
      zoom_level : Float,
      show_manual_controls : Bool,
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
      show_manual_controls = True,
      displayed_tab = Nothing,
      previous_action = Nothing
   }

-- Zoom ------------------------------------------------------------------------
get_zoom_level : Type -> Float
get_zoom_level ui = ui.zoom_level

reset_zoom_level : Type -> Type
reset_zoom_level ui = {ui | zoom_level = 1.0}

mod_zoom_level : Type -> Float -> Type
mod_zoom_level ui mod = {ui | zoom_level = (mod * ui.zoom_level)}

-- Tab -------------------------------------------------------------------------
try_getting_displayed_tab : Type -> (Maybe Tab)
try_getting_displayed_tab ui = ui.displayed_tab

set_displayed_tab : Type -> Tab -> Type
set_displayed_tab ui tab = {ui | displayed_tab = (Just tab)}

reset_displayed_tab : Type -> Type
reset_displayed_tab ui = {ui | displayed_tab = Nothing}

to_string : Tab -> String
to_string tab =
   case tab of
      StatusTab -> "Status"
      CharactersTab -> "Characters"
      SettingsTab -> "Settings"
      TimelineTab -> "Timeline"

get_all_tabs : (List Tab)
get_all_tabs =
   [StatusTab, CharactersTab, SettingsTab, TimelineTab]

-- ManualControls --------------------------------------------------------------
has_manual_controls_enabled : Type -> Bool
has_manual_controls_enabled ui = ui.show_manual_controls

toggle_manual_controls : Type -> Type
toggle_manual_controls ui =
   if (ui.show_manual_controls)
   then
      {ui | show_manual_controls = False}
   else
      {ui | show_manual_controls = True}

set_enable_manual_controls : Type -> Bool -> Type
set_enable_manual_controls ui val = {ui | show_manual_controls = val}

-- Previous Action -------------------------------------------------------------
has_focus : Type -> Bool
has_focus ui = True

set_previous_action : Type -> (Maybe Action) -> Type
set_previous_action ui act = {ui | previous_action = act}

get_previous_action : Type -> (Maybe Action)
get_previous_action ui = ui.previous_action
