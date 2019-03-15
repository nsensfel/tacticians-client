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

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Glyph
import Struct.GlyphBoard

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      index : Int,
      name : String,
      portrait_id : String,
      main_weapon_id : String,
      secondary_weapon_id : String,
      armor_id : String,
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

get_main_weapon_id : Type -> String
get_main_weapon_id char = char.main_weapon_id

get_secondary_weapon_id : Type -> String
get_secondary_weapon_id char = char.secondary_weapon_id

get_armor_id : Type -> String
get_armor_id char = char.armor_id

get_glyph_board_id : Type -> String
get_glyph_board_id char = char.glyph_board_id

get_glyph_ids : Type -> (List String)
get_glyph_ids char = char.glyph_ids

from_character : Struct.Character.Type -> Type
from_character char =
   {
      index = (Struct.Character.get_index char),
      name = (Struct.Character.get_name char),
      portrait_id =
         (BattleCharacters.Struct.Portrait.get_id
            (Struct.Character.get_portrait char)
         ),
      armor_id =
         (BattleCharacters.Struct.Armor.get_id
            (Struct.Character.get_armor char)
         ),
      main_weapon_id =
         (BattleCharacters.Struct.Weapon.get_id
            (Struct.Character.get_primary_weapon char)
         ),
      secondary_weapon_id =
         (BattleCharacters.Struct.Weapon.get_id
            (Struct.Character.get_secondary_weapon char)
         ),
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
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.required "ix" Json.Decode.int)
      |> (Json.Decode.Pipeline.required "nam" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "prt" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "awp" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "swp" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ar" Json.Decode.string)
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
         ("awp", (Json.Encode.string char.main_weapon_id)),
         ("swp", (Json.Encode.string char.secondary_weapon_id)),
         ("ar", (Json.Encode.string char.armor_id)),
         ("gb", (Json.Encode.string char.glyph_board_id)),
         (
            "gls",
            (Json.Encode.list
               (Json.Encode.string)
               char.glyph_ids
            )
         )
      ]
   )
