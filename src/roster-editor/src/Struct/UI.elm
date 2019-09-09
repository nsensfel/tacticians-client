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
      get_glyph_slot
   )

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
      glyph_slot : (Int, Int)
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
      glyph_slot = (-1, 0)
   }

-- Tab -------------------------------------------------------------------------
get_displayed_tab : Type -> Tab
get_displayed_tab ui = ui.displayed_tab

set_displayed_tab : Tab -> Type -> Type
set_displayed_tab tab ui = {ui | displayed_tab = tab}

reset_displayed_tab : Type -> Type
reset_displayed_tab ui = {ui | displayed_tab = CharacterSelectionTab}

get_glyph_slot : Type -> (Int, Int)
get_glyph_slot ui = ui.glyph_slot

set_glyph_slot : (Int, Int) -> Type -> Type
set_glyph_slot slot_and_factor ui = {ui | glyph_slot = slot_and_factor}
