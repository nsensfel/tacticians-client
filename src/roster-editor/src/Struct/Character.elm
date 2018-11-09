module Struct.Character exposing
   (
      Type,
      new,
      get_index,
      get_name,
      set_name,
      get_portrait,
      set_portrait,
      get_armor,
      set_armor,
      get_current_omnimods,
      get_attributes,
      get_statistics,
      get_weapons,
      set_weapons,
      get_glyph_board,
      set_glyph_board,
      get_glyphs,
      set_glyph,
      set_was_edited,
      get_was_edited
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
import Struct.Attributes
import Struct.Glyph
import Struct.GlyphBoard
import Struct.Omnimods
import Struct.Portrait
import Struct.Statistics
import Struct.Weapon
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      ix : Int,
      name : String,
      portrait : Struct.Portrait.Type,
      attributes : Struct.Attributes.Type,
      statistics : Struct.Statistics.Type,
      weapons : Struct.WeaponSet.Type,
      armor : Struct.Armor.Type,
      glyph_board : Struct.GlyphBoard.Type,
      glyphs : (Array.Array Struct.Glyph.Type),
      current_omnimods : Struct.Omnimods.Type,
      was_edited : Bool
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
refresh_omnimods : Type -> Type
refresh_omnimods char =
   let
      current_omnimods =
         (Struct.Omnimods.merge
            (Struct.Omnimods.merge
               (Struct.Weapon.get_omnimods
                  (Struct.WeaponSet.get_active_weapon char.weapons)
               )
               (Struct.Armor.get_omnimods char.armor)
            )
            (Struct.GlyphBoard.get_omnimods_with_glyphs
               char.glyphs
               char.glyph_board
            )
         )
      current_attributes =
         (Struct.Omnimods.apply_to_attributes
            current_omnimods
            (Struct.Attributes.default)
         )
      current_statistics =
         (Struct.Omnimods.apply_to_statistics
            current_omnimods
            (Struct.Statistics.new_raw current_attributes)
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
      (Maybe Struct.Portrait.Type) ->
      (Maybe Struct.Weapon.Type) ->
      (Maybe Struct.Weapon.Type) ->
      (Maybe Struct.Armor.Type) ->
      (Maybe Struct.GlyphBoard.Type) ->
      (List (Maybe Struct.Glyph.Type)) ->
      Type
   )
new index name m_portrait m_main_wp m_sec_wp m_armor m_board m_glyphs =
   {
      ix = index,
      name = name,
      portrait =
         (
            case m_portrait of
               (Just portrait) -> portrait
               Nothing -> (Struct.Portrait.default)
         ),
      attributes = (Struct.Attributes.default),
      statistics = (Struct.Statistics.new_raw (Struct.Attributes.default)),
      weapons =
         (Struct.WeaponSet.new
            (
               case m_main_wp of
                  (Just w) -> w
                  Nothing -> (Struct.Weapon.default)
            )
            (
               case m_sec_wp of
                  (Just w) -> w
                  Nothing -> (Struct.Weapon.default)
            )
         ),
      armor =
         (
            case m_armor of
               (Just armor) -> armor
               Nothing -> (Struct.Armor.default)
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
      current_omnimods = (Struct.Omnimods.none),
      was_edited = False
   }
get_index : Type -> Int
get_index c = c.ix

get_name : Type -> String
get_name c = c.name

set_name : String -> Type -> Type
set_name name char = {char | name = name}

get_portrait : Type -> Struct.Portrait.Type
get_portrait c = c.portrait

set_portrait : Struct.Portrait.Type -> Type -> Type
set_portrait portrait char = {char | portrait = portrait}

get_current_omnimods : Type -> Struct.Omnimods.Type
get_current_omnimods c = c.current_omnimods

get_attributes : Type -> Struct.Attributes.Type
get_attributes char = char.attributes

get_statistics : Type -> Struct.Statistics.Type
get_statistics char = char.statistics

get_weapons : Type -> Struct.WeaponSet.Type
get_weapons char = char.weapons

set_weapons : Struct.WeaponSet.Type -> Type -> Type
set_weapons weapons char = (refresh_omnimods {char | weapons = weapons})

get_armor : Type -> Struct.Armor.Type
get_armor char = char.armor

set_armor : Struct.Armor.Type -> Type -> Type
set_armor armor char = (refresh_omnimods {char | armor = armor})

get_glyph_board : Type -> Struct.GlyphBoard.Type
get_glyph_board char = char.glyph_board

set_glyph_board : Struct.GlyphBoard.Type -> Type -> Type
set_glyph_board glyph_board char =
   (refresh_omnimods
      {char |
         glyph_board = glyph_board,
         glyphs = (Array.empty)
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
