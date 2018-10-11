module Struct.Character exposing
   (
      Type,
      get_index,
      get_name,
      get_portrait_id,
      get_armor,
      get_current_omnimods,
      get_attributes,
      get_statistics,
      get_weapons,
      set_weapons,
--      get_glyph_board,
--      get_glyphes,
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
      portrait : String,
      attributes : Struct.Attributes.Type,
      statistics : Struct.Statistics.Type,
      weapons : Struct.WeaponSet.Type,
      armor : Struct.Armor.Type,
      glyph_board : Struct.GlyphBoard.Type,
      glyphes : (Array.Array Struct.Glyph.Type),
      current_omnimods : Struct.Omnimods.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
finish_decoding : PartiallyDecoded -> (Type, Int, Int, Int)
finish_decoding add_char =
   let
      weapon_set = (Struct.WeaponSet.new Struct.Weapon.none Struct.Weapon.none)
      armor = Struct.Armor.none
      glyph_board = Struct.GlyphBoard.none
      glyphes = (Array.empty)
      default_attributes = (Struct.Attributes.default)
      almost_char =
         {
            ix = add_char.ix,
            name = add_char.nam,
            portrait = add_char.prt,
            attributes = default_attributes,
            statistics = (Struct.Statistics.new_raw default_attributes),
            weapons = weapon_set,
            armor = armor,
            glyph_board = glyph_board,
            glyphes = glyphes,
            current_omnimods = add_char.current_omnimods
         }
   in
      (almost_char, add_char.awp, add_char.swp, add_char.ar)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_index : Type -> Int
get_index c = c.ix

get_name : Type -> String
get_name c = c.name

get_portrait_id : Type -> String
get_portrait_id c = c.portrait

get_current_omnimods : Type -> Struct.Omnimods.Type
get_current_omnimods c = c.current_omnimods

get_attributes : Type -> Struct.Attributes.Type
get_attributes char = char.attributes

get_statistics : Type -> Struct.Statistics.Type
get_statistics char = char.statistics

get_weapons : Type -> Struct.WeaponSet.Type
get_weapons char = char.weapons

get_armor : Type -> Struct.Armor.Type
get_armor char = char.armor

get_armor_variation : Type -> String
get_armor_variation char =
   case char.portrait of
      -- Currently hardcoded to match crows from characters.css
      "11" -> "1"
      "4" -> "1"
      _ -> "0"

set_weapons : Struct.WeaponSet.Type -> Type -> Type
set_weapons weapons char =
   {char |
      weapons = weapons
   }

decoder : (Json.Decode.Decoder (Type, Int, Int, Int))
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
