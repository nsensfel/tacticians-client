module Struct.CharacterRecord exposing
   (
      Type,
      get_index,
      get_name,
      get_portrait_id,
      get_armor_id,
      get_main_weapon_id,
      get_secondary_weapon_id,
      get_glyph_board_id,
      get_glyph_ids,
      from_character,
      decoder,
      encode
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
import Struct.Character
import Struct.Glyph
import Struct.GlyphBoard
import Struct.Portrait
import Struct.Weapon
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      index : Int,
      name : String,
      portrait_id : String,
      main_weapon_id : Int,
      secondary_weapon_id : Int,
      armor_id : Int,
      glyph_board_id : String,
      glyph_ids : (List String)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_index : Type -> Int
get_index c = c.index

get_name : Type -> String
get_name c = c.name

get_portrait_id : Type -> String
get_portrait_id c = c.portrait_id

get_main_weapon_id : Type -> Int
get_main_weapon_id char = char.main_weapon_id

get_secondary_weapon_id : Type -> Int
get_secondary_weapon_id char = char.secondary_weapon_id

get_armor_id : Type -> Int
get_armor_id char = char.armor_id

get_glyph_board_id : Type -> String
get_glyph_board_id char = char.glyph_board_id

get_glyph_ids : Type -> (List String)
get_glyph_ids char = char.glyph_ids

from_character : Struct.Character.Type -> Type
from_character char =
   let
      weapons = (Struct.Character.get_weapons char)
   in
   {
      index = (Struct.Character.get_index char),
      name = (Struct.Character.get_name char),
      portrait_id =
         (Struct.Portrait.get_id (Struct.Character.get_portrait char)),
      armor_id = (Struct.Armor.get_id (Struct.Character.get_armor char)),
      main_weapon_id =
         (Struct.Weapon.get_id (Struct.WeaponSet.get_active_weapon weapons)),
      secondary_weapon_id =
         (Struct.Weapon.get_id (Struct.WeaponSet.get_secondary_weapon weapons)),
      glyph_board_id =
         (Struct.GlyphBoard.get_id (Struct.Character.get_glyph_board char)),
      glyph_ids =
         (Array.toList
            (Array.map
               (Struct.Glyph.get_id)
               (Struct.Character.get_glyphs char)
            )
         )
   }

decoder : (Json.Decode.Decoder Type)
decoder =
   (Json.Decode.Pipeline.decode
      Type
      |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "prt" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "awp" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "swp" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "ar" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "gb" Json.Decode.string)
      |> (Json.Decode.Pipeline.required
            "gls"
            (Json.Decode.list Json.Decode.string)
         )
   )

encode : Type -> Json.Encode.Value
encode char =
   (Json.Encode.object
      [
         ("ix", (Json.Encode.int char.index)),
         ("nam", (Json.Encode.string char.name)),
         ("prt", (Json.Encode.string char.portrait_id)),
         ("awp", (Json.Encode.int char.main_weapon_id)),
         ("swp", (Json.Encode.int char.secondary_weapon_id)),
         ("ar", (Json.Encode.int char.armor_id)),
         ("gb", (Json.Encode.string char.glyph_board_id)),
         (
            "gls",
            (Json.Encode.list
               (List.map
                  (Json.Encode.string)
                  char.glyph_ids
               )
            )
         )
      ]
   )
