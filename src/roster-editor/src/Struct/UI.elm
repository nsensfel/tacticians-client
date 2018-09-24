module Struct.UI exposing
   (
      Type,
      Tab(..),
      default,
      -- Tab
      get_displayed_tab,
      set_displayed_tab,
      reset_displayed_tab
   )

-- Elm -------------------------------------------------------------------------

-- Roster Editor ---------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Tab =
   CharacterSelectionTab
   | PortraitSelectionTab
-- | AccessorySelectionTab
   | WeaponSelectionTab
   | ArmorSelectionTab
   | GlyphManagementTab

type alias Type =
   {
      displayed_tab : Tab
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
      displayed_tab = CharacterSelectionTab,
   }

-- Tab -------------------------------------------------------------------------
get_displayed_tab : Type -> Tab
get_displayed_tab ui = ui.displayed_tab

set_displayed_tab : Tab -> Type -> Type
set_displayed_tab tab ui = {ui | displayed_tab = tab}

reset_displayed_tab : Type -> Type
reset_displayed_tab ui = {ui | displayed_tab = CharacterSelectionTab}
