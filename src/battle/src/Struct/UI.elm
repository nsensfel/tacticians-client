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
      maybe_get_displayed_tab,
      set_displayed_tab,
      reset_displayed_tab,
      tab_to_string,
      get_all_tabs,

      -- Navigator
      maybe_get_displayed_navigator,
      set_displayed_navigator,
      reset_displayed_navigator,

      -- Manual Controls
      has_manual_controls_enabled,

      -- Previous Action
      get_previous_action,
      set_previous_action
   )

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location

-- Local Module ----------------------------------------------------------------
import Struct.Navigator

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Tab =
   TileStatusTab BattleMap.Struct.Location.Ref
   | CharacterStatusTab Int
   | CharactersTab
   | SettingsTab
   | TimelineTab

type Action =
   UsedManualControls
   | SelectedLocation BattleMap.Struct.Location.Ref
   | SelectedCharacter Int
   | AttackedCharacter Int

type alias Type =
   {
      zoom_level : Float,
      show_manual_controls : Bool,
      displayed_tab : (Maybe Tab),
      previous_action : (Maybe Action),
      displayed_navigator : (Maybe Struct.Navigator.Type)
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
      previous_action = Nothing,
      displayed_navigator = Nothing
   }

-- Zoom ------------------------------------------------------------------------
get_zoom_level : Type -> Float
get_zoom_level ui = ui.zoom_level

reset_zoom_level : Type -> Type
reset_zoom_level ui = {ui | zoom_level = 1.0}

mod_zoom_level : Float -> Type -> Type
mod_zoom_level mod ui = {ui | zoom_level = (mod * ui.zoom_level)}

-- Tab -------------------------------------------------------------------------
maybe_get_displayed_tab : Type -> (Maybe Tab)
maybe_get_displayed_tab ui = ui.displayed_tab

set_displayed_tab : Tab -> Type -> Type
set_displayed_tab tab ui = {ui | displayed_tab = (Just tab)}

reset_displayed_tab : Type -> Type
reset_displayed_tab ui = {ui | displayed_tab = Nothing}

tab_to_string : Tab -> String
tab_to_string tab =
   case tab of
      (TileStatusTab _) -> "Status"
      (CharacterStatusTab _) -> "Status"
      CharactersTab -> "Characters"
      SettingsTab -> "Settings"
      TimelineTab -> "Timeline"

get_all_tabs : (List Tab)
get_all_tabs =
   [CharactersTab, SettingsTab, TimelineTab]

-- Navigator -------------------------------------------------------------------
maybe_get_displayed_navigator : Type -> (Maybe Struct.Navigator.Type)
maybe_get_displayed_navigator ui = ui.displayed_navigator

set_displayed_navigator : Struct.Navigator.Type -> Type -> Type
set_displayed_navigator nav ui = {ui | displayed_navigator = (Just nav)}

reset_displayed_navigator : Type -> Type
reset_displayed_navigator ui = {ui | displayed_navigator = Nothing}

-- ManualControls --------------------------------------------------------------
has_manual_controls_enabled : Type -> Bool
has_manual_controls_enabled ui = ui.show_manual_controls

toggle_manual_controls : Type -> Type
toggle_manual_controls ui =
   if (ui.show_manual_controls)
   then {ui | show_manual_controls = False}
   else {ui | show_manual_controls = True}

set_enable_manual_controls : Bool -> Type -> Type
set_enable_manual_controls val ui = {ui | show_manual_controls = val}

-- Previous Action -------------------------------------------------------------
set_previous_action : (Maybe Action) -> Type -> Type
set_previous_action act ui = {ui | previous_action = act}

get_previous_action : Type -> (Maybe Action)
get_previous_action ui = ui.previous_action
