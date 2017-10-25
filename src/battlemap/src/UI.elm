module UI exposing
   (
      Type,
      Tab(..),
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
      has_just_used_manual_controls,
      set_has_just_used_manual_controls
   )

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Tab =
   StatusTab
   | CharactersTab
   | SettingsTab

type alias Type =
   {
      zoom_level : Float,
      show_manual_controls : Bool,
      just_used_manual_controls : Bool,
      displayed_tab : (Maybe Tab)
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
      just_used_manual_controls = False,
      displayed_tab = (Just StatusTab)
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

get_all_tabs : (List Tab)
get_all_tabs =
   [StatusTab, CharactersTab, SettingsTab]
-- ManualControls --------------------------------------------------------------
has_manual_controls_enabled : Type -> Bool
has_manual_controls_enabled ui = ui.show_manual_controls

has_just_used_manual_controls : Type -> Bool
has_just_used_manual_controls ui = ui.just_used_manual_controls

set_has_just_used_manual_controls : Type -> Bool -> Type
set_has_just_used_manual_controls ui val =
   {ui | just_used_manual_controls = val}

toggle_manual_controls : Type -> Type
toggle_manual_controls ui =
   if (ui.show_manual_controls)
   then
      {ui | show_manual_controls = False}
   else
      {ui | show_manual_controls = True}

set_enable_toggle_manual_controls : Type -> Bool -> Type
set_enable_toggle_manual_controls ui val = {ui | show_manual_controls = val}
