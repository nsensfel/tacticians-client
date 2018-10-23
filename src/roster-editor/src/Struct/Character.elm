module Struct.Character exposing
   (
      Type,
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
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode
import Json.Decode.Pipeline

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
type alias PartiallyDecoded =
   {
      ix : Int,
      nam : String,
      prt : String,
      awp : Int,
      swp : Int,
      ar : Int,
      gb : String,
      gls : (List Int),
      current_omnimods : Struct.Omnimods.Type
   }

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
      current_omnimods : Struct.Omnimods.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
finish_decoding : PartiallyDecoded -> (Type, String, Int, Int, Int)
finish_decoding add_char =
   let
      weapon_set = (Struct.WeaponSet.new Struct.Weapon.none Struct.Weapon.none)
      armor = Struct.Armor.none
      glyph_board = Struct.GlyphBoard.none
      glyphs = (Array.empty)
      default_attributes = (Struct.Attributes.default)
      almost_char =
         {
            ix = add_char.ix,
            name = add_char.nam,
            portrait = (Struct.Portrait.default),
            attributes = default_attributes,
            statistics = (Struct.Statistics.new_raw default_attributes),
            weapons = weapon_set,
            armor = armor,
            glyph_board = glyph_board,
            glyphs = glyphs,
            current_omnimods = add_char.current_omnimods
         }
   in
      (almost_char, add_char.prt, add_char.awp, add_char.swp, add_char.ar)

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

decoder : (Json.Decode.Decoder (Type, String, Int, Int, Int))
decoder =
   (Json.Decode.map
      (finish_decoding)
      (Json.Decode.Pipeline.decode
         PartiallyDecoded
         |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "prt" Json.Decode.string)
         |> (Json.Decode.Pipeline.required "awp" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "swp" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "ar" Json.Decode.int)
         |> (Json.Decode.Pipeline.required "gb" Json.Decode.string)
         |> (Json.Decode.Pipeline.required
               "gls"
               (Json.Decode.list Json.Decode.int)
            )
         |> (Json.Decode.Pipeline.hardcoded (Struct.Omnimods.none))
      )
   )
