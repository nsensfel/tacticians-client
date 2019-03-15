module Struct.UI exposing
   (
      Type,
      Tab(..),
      default,
      -- Tab
      get_displayed_tab,
      set_displayed_tab,
      reset_displayed_tab,
      -- Which glyph slot is being edited?
      set_glyph_slot,
      get_glyph_slot,
      -- Display Tile Costs
      get_display_tile_cost,
      toggle_display_tile_cost
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
   | GlyphSelectionTab
   | GlyphBoardSelectionTab
   | GlyphManagementTab

type alias Type =
   {
      displayed_tab : Tab,
      glyph_slot : Int,
      display_tile_cost : Bool
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
      glyph_slot = -1
   }

-- Tab -------------------------------------------------------------------------
get_displayed_tab : Type -> Tab
get_displayed_tab ui = ui.displayed_tab

set_displayed_tab : Tab -> Type -> Type
set_displayed_tab tab ui = {ui | displayed_tab = tab}

reset_displayed_tab : Type -> Type
reset_displayed_tab ui = {ui | displayed_tab = CharacterSelectionTab}

get_glyph_slot : Type -> Int
get_glyph_slot ui = ui.glyph_slot

set_glyph_slot : Int -> Type -> Type
set_glyph_slot tab ui = {ui | glyph_slot = tab}

-- Tile Cost -------------------------------------------------------------------
toggle_display_tile_cost : Type -> Type
toggle_display_tile_cost ui =
   {ui | display_tile_cost = (not ui.display_tile_cost)}

get_display_tile_cost : Type -> Bool
get_display_tile_cost ui = ui.display_tile_cost
