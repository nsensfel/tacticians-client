module Struct.UI exposing
   (
      Type,
      Tab(..),
      default,
      -- Tab
      get_displayed_tab,
      set_displayed_tab,
      reset_displayed_tab,
      -- Main or Secondary Weapon?
      set_is_selecting_main_weapon,
      is_selecting_main_weapon,
      -- Which glyph slot is being edited?
      set_glyph_slot,
      get_glyph_slot
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
      is_selecting_main_weapon : Bool,
      glyph_slot : Int
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
      is_selecting_main_weapon = False,
      glyph_slot = -1
   }

-- Tab -------------------------------------------------------------------------
get_displayed_tab : Type -> Tab
get_displayed_tab ui = ui.displayed_tab

set_displayed_tab : Tab -> Type -> Type
set_displayed_tab tab ui = {ui | displayed_tab = tab}

reset_displayed_tab : Type -> Type
reset_displayed_tab ui = {ui | displayed_tab = CharacterSelectionTab}

set_is_selecting_main_weapon : Bool -> Type -> Type
set_is_selecting_main_weapon val ui = {ui | is_selecting_main_weapon = val}

is_selecting_main_weapon : Type -> Bool
is_selecting_main_weapon ui = ui.is_selecting_main_weapon

get_glyph_slot : Type -> Int
get_glyph_slot ui = ui.glyph_slot

set_glyph_slot : Int -> Type -> Type
set_glyph_slot tab ui = {ui | glyph_slot = tab}
