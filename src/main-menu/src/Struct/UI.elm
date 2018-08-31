module Struct.UI exposing
   (
      Type,
      Tab(..),
      default,
      -- Tab
      try_getting_displayed_tab,
      set_displayed_tab,
      reset_displayed_tab,
      to_string
   )

-- Main Menu -------------------------------------------------------------------

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Tab =
   CampaignsTab
   | InvasionsTab
   | EventsTab
   | CharactersTab
   | MapsEditorTab
   | AccountTab

type alias Type =
   {
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
      displayed_tab = Nothing
   }

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
      CampaignsTab -> "Campaigns"
      InvasionsTab -> "Invasions"
      EventsTab -> "Events"
      CharactersTab -> "Character Editor"
      MapsEditorTab -> "Map Editor"
      AccountTab -> "Account Settings"
