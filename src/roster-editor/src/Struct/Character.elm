module Struct.Character exposing
   (
      Type,
      new,
      get_index,
      get_battle_index,
      set_battle_index,
      get_name,
      set_name,
      get_portrait,
      set_portrait,
      get_armor,
      set_armor,
      get_current_omnimods,
      get_attributes,
      get_statistics,
      get_primary_weapon,
      set_primary_weapon,
      get_secondary_weapon,
      set_secondary_weapon,
      get_is_using_secondary,
      get_glyph_board,
      set_glyph_board,
      get_glyphs,
      set_glyph,
      set_was_edited,
      get_was_edited,
      switch_weapons
   )

-- Elm -------------------------------------------------------------------------
import Array

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods
import Battle.Struct.Attributes
import Battle.Struct.Statistics

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon

-- Local Module ----------------------------------------------------------------
import Struct.Glyph
import Struct.GlyphBoard

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      ix : Int,
      battle_ix : Int,
      name : String,
      portrait : BattleCharacters.Struct.Portrait.Type,
      attributes : Battle.Struct.Attributes.Type,
      statistics : Battle.Struct.Statistics.Type,
      primary_weapon : BattleCharacters.Struct.Weapon.Type,
      secondary_weapon : BattleCharacters.Struct.Weapon.Type,
      is_using_secondary : Bool,
      armor : BattleCharacters.Struct.Armor.Type,
      glyph_board : Struct.GlyphBoard.Type,
      glyphs : (Array.Array Struct.Glyph.Type),
      current_omnimods : Battle.Struct.Omnimods.Type,
      was_edited : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
refresh_omnimods : Type -> Type
refresh_omnimods char =
   let
      current_omnimods =
         (Battle.Struct.Omnimods.merge
            (Battle.Struct.Omnimods.merge
               (BattleCharacters.Struct.Weapon.get_omnimods
                  (
                     if (char.is_using_secondary)
                     then char.secondary_weapon
                     else char.primary_weapon
                  )
               )
               (BattleCharacters.Struct.Armor.get_omnimods char.armor)
            )
            (Struct.GlyphBoard.get_omnimods_with_glyphs
               char.glyphs
               char.glyph_board
            )
         )
      current_attributes =
         (Battle.Struct.Omnimods.apply_to_attributes
            current_omnimods
            (Battle.Struct.Attributes.default)
         )
      current_statistics =
         (Battle.Struct.Omnimods.apply_to_statistics
            current_omnimods
            (Battle.Struct.Statistics.new_raw current_attributes)
         )
   in
      {char |
         attributes = current_attributes,
         statistics = current_statistics,
         current_omnimods = current_omnimods
      }


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : (
      Int ->
      String ->
      (Maybe BattleCharacters.Struct.Portrait.Type) ->
      (Maybe BattleCharacters.Struct.Weapon.Type) ->
      (Maybe BattleCharacters.Struct.Weapon.Type) ->
      (Maybe BattleCharacters.Struct.Armor.Type) ->
      (Maybe Struct.GlyphBoard.Type) ->
      (List (Maybe Struct.Glyph.Type)) ->
      Type
   )
new index name m_portrait m_main_wp m_sec_wp m_armor m_board m_glyphs =
   (refresh_omnimods
      {
         ix = index,
         battle_ix = -1,
         name = name,
         portrait =
            (
               case m_portrait of
                  (Just portrait) -> portrait
                  Nothing -> (BattleCharacters.Struct.Portrait.default)
            ),
         attributes = (Battle.Struct.Attributes.default),
         statistics =
            (Battle.Struct.Statistics.new_raw
               (Battle.Struct.Attributes.default)
            ),
         primary_weapon =
               (
                  case m_main_wp of
                     (Just w) -> w
                     Nothing -> (BattleCharacters.Struct.Weapon.default)
               ),
         secondary_weapon =
               (
                  case m_sec_wp of
                     (Just w) -> w
                     Nothing -> (BattleCharacters.Struct.Weapon.default)
               ),
         armor =
            (
               case m_armor of
                  (Just armor) -> armor
                  Nothing -> (BattleCharacters.Struct.Armor.default)
            ),
         glyph_board =
            (
               case m_board of
                  (Just board) -> board
                  Nothing -> (Struct.GlyphBoard.default)
            ),
         glyphs =
            (Array.fromList
               (List.map
                  (\m_g ->
                     case m_g of
                        (Just g) -> g
                        Nothing -> (Struct.Glyph.default)
                  )
                  m_glyphs
               )
            ),
         is_using_secondary = False,
         current_omnimods = (Battle.Struct.Omnimods.none),
         was_edited = False
      }
   )

get_index : Type -> Int
get_index c = c.ix

get_battle_index : Type -> Int
get_battle_index c = c.battle_ix

set_battle_index : Int -> Type -> Type
set_battle_index battle_ix c = {c | battle_ix = battle_ix}

get_name : Type -> String
get_name c = c.name

set_name : String -> Type -> Type
set_name name char = {char | name = name}

get_portrait : Type -> BattleCharacters.Struct.Portrait.Type
get_portrait c = c.portrait

set_portrait : BattleCharacters.Struct.Portrait.Type -> Type -> Type
set_portrait portrait char = {char | portrait = portrait}

get_current_omnimods : Type -> Battle.Struct.Omnimods.Type
get_current_omnimods c = c.current_omnimods

get_attributes : Type -> Battle.Struct.Attributes.Type
get_attributes char = char.attributes

get_statistics : Type -> Battle.Struct.Statistics.Type
get_statistics char = char.statistics

get_primary_weapon : Type -> BattleCharacters.Struct.Weapon.Type
get_primary_weapon char = char.primary_weapon

set_primary_weapon : BattleCharacters.Struct.Weapon.Type -> Type -> Type
set_primary_weapon wp char = (refresh_omnimods {char | primary_weapon = wp})

get_secondary_weapon : Type -> BattleCharacters.Struct.Weapon.Type
get_secondary_weapon char = char.secondary_weapon

set_secondary_weapon : BattleCharacters.Struct.Weapon.Type -> Type -> Type
set_secondary_weapon wp char = (refresh_omnimods {char | secondary_weapon = wp})

get_is_using_secondary : Type -> Bool
get_is_using_secondary char = char.is_using_secondary

get_armor : Type -> BattleCharacters.Struct.Armor.Type
get_armor char = char.armor

set_armor : BattleCharacters.Struct.Armor.Type -> Type -> Type
set_armor armor char = (refresh_omnimods {char | armor = armor})

get_glyph_board : Type -> Struct.GlyphBoard.Type
get_glyph_board char = char.glyph_board

set_glyph_board : Struct.GlyphBoard.Type -> Type -> Type
set_glyph_board glyph_board char =
   (refresh_omnimods
      {char |
         glyph_board = glyph_board,
         glyphs =
            (Array.repeat
               (List.length (Struct.GlyphBoard.get_slots glyph_board))
               (Struct.Glyph.none)
            )
      }
   )

get_glyphs : Type -> (Array.Array Struct.Glyph.Type)
get_glyphs char = char.glyphs

set_glyph : Int -> Struct.Glyph.Type -> Type -> Type
set_glyph index glyph char =
   (refresh_omnimods {char | glyphs = (Array.set index glyph char.glyphs)})

get_was_edited : Type -> Bool
get_was_edited char = char.was_edited

set_was_edited : Bool -> Type -> Type
set_was_edited val char = {char | was_edited = val}

switch_weapons : Type -> Type
switch_weapons char =
   (refresh_omnimods
      {char | is_using_secondary = (not char.is_using_secondary)}
   )
