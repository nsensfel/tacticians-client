module BattleCharacters.Struct.Equipment exposing
   (
      Type,
      Unresolved,
      get_primary_weapon,
      get_secondary_weapon,
      get_armor,
      get_portrait,
      get_glyph_board,
      get_glyphs,
      get_skill,
      set_primary_weapon,
      set_secondary_weapon,
      set_armor,
      set_portrait,
      set_glyph_board,
      set_glyphs,
      set_glyph,
      set_skill,
      decoder,
      encode,
      resolve,
      to_unresolved
   )

-- Elm -------------------------------------------------------------------------
import Array

import List

import Json.Decode
import Json.Decode.Pipeline

import Json.Encode

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.DataSet
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.GlyphBoard
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Skill
import BattleCharacters.Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      primary : BattleCharacters.Struct.Weapon.Type,
      secondary : BattleCharacters.Struct.Weapon.Type,
      armor : BattleCharacters.Struct.Armor.Type,
      portrait : BattleCharacters.Struct.Portrait.Type,
      glyph_board : BattleCharacters.Struct.GlyphBoard.Type,
      glyphs : (Array.Array BattleCharacters.Struct.Glyph.Type),
      skill : BattleCharacters.Struct.Skill.Type
   }

type alias Unresolved =
   {
      primary : BattleCharacters.Struct.Weapon.Ref,
      secondary : BattleCharacters.Struct.Weapon.Ref,
      armor : BattleCharacters.Struct.Armor.Ref,
      portrait : BattleCharacters.Struct.Portrait.Ref,
      glyph_board : BattleCharacters.Struct.GlyphBoard.Ref,
      glyphs : (Array.Array BattleCharacters.Struct.Glyph.Ref),
      skill : BattleCharacters.Struct.Skill.Ref
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_primary_weapon : Type -> BattleCharacters.Struct.Weapon.Type
get_primary_weapon equipment = equipment.primary

get_secondary_weapon : Type -> BattleCharacters.Struct.Weapon.Type
get_secondary_weapon equipment = equipment.secondary

get_armor : Type -> BattleCharacters.Struct.Armor.Type
get_armor equipment = equipment.armor

get_portrait : Type -> BattleCharacters.Struct.Portrait.Type
get_portrait equipment = equipment.portrait

get_glyph_board : Type -> BattleCharacters.Struct.GlyphBoard.Type
get_glyph_board equipment = equipment.glyph_board

get_glyphs : Type -> (Array.Array BattleCharacters.Struct.Glyph.Type)
get_glyphs equipment = equipment.glyphs

get_skill : Type -> BattleCharacters.Struct.Skill.Type
get_skill equipment = equipment.skill

set_primary_weapon : BattleCharacters.Struct.Weapon.Type -> Type -> Type
set_primary_weapon wp equipment = { equipment | primary = wp }

set_secondary_weapon : BattleCharacters.Struct.Weapon.Type -> Type -> Type
set_secondary_weapon wp equipment = { equipment | secondary = wp }

set_armor : BattleCharacters.Struct.Armor.Type -> Type -> Type
set_armor ar equipment = { equipment | armor = ar }

set_portrait : BattleCharacters.Struct.Portrait.Type -> Type -> Type
set_portrait pt equipment = { equipment | portrait = pt }

set_glyph_board : BattleCharacters.Struct.GlyphBoard.Type -> Type -> Type
set_glyph_board gb equipment =
   {equipment |
      glyph_board = gb,
      glyphs =
         (Array.repeat
            (List.length (BattleCharacters.Struct.GlyphBoard.get_slots gb))
            (BattleCharacters.Struct.Glyph.none)
         )
   }

set_glyphs : (Array.Array BattleCharacters.Struct.Glyph.Type) -> Type -> Type
set_glyphs gl equipment = { equipment | glyphs = gl }

set_glyph : Int -> BattleCharacters.Struct.Glyph.Type -> Type -> Type
set_glyph index glyph equipment =
   { equipment | glyphs = (Array.set index glyph equipment.glyphs) }

set_skill : BattleCharacters.Struct.Skill.Type -> Type -> Type
set_skill sk equipment = { equipment | skill = sk }

decoder : (Json.Decode.Decoder Unresolved)
decoder =
   (Json.Decode.succeed
      Unresolved
      |> (Json.Decode.Pipeline.required "pr" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "sc" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "ar" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "pt" Json.Decode.string)
      |> (Json.Decode.Pipeline.required "gb" Json.Decode.string)
      |>
         (Json.Decode.Pipeline.required
            "gl"
            (Json.Decode.array (Json.Decode.string))
         )
      |> (Json.Decode.Pipeline.required "sk" Json.Decode.string)
   )

encode : Unresolved -> Json.Encode.Value
encode ref =
   (Json.Encode.object
      [
         ("pr", (Json.Encode.string ref.primary)),
         ("sc", (Json.Encode.string ref.secondary)),
         ("ar", (Json.Encode.string ref.armor)),
         ("pt", (Json.Encode.string ref.portrait)),
         ("gb", (Json.Encode.string ref.glyph_board)),
         ("sk", (Json.Encode.string ref.skill)),
         ("gl", (Json.Encode.array (Json.Encode.string) ref.glyphs))
      ]
   )

resolve : BattleCharacters.Struct.DataSet.Type -> Unresolved -> Type
resolve dataset ref =
   {
      primary =
         (BattleCharacters.Struct.DataSet.get_weapon ref.primary dataset),
      secondary =
         (BattleCharacters.Struct.DataSet.get_weapon ref.secondary dataset),
      armor =
         (BattleCharacters.Struct.DataSet.get_armor ref.armor dataset),
      portrait =
         (BattleCharacters.Struct.DataSet.get_portrait ref.portrait dataset),
      glyph_board =
         (BattleCharacters.Struct.DataSet.get_glyph_board
            ref.glyph_board dataset
         ),
      glyphs =
         (Array.map
            (\gl_id ->
               (BattleCharacters.Struct.DataSet.get_glyph gl_id dataset)
            )
            ref.glyphs
         ),
      skill =
         (BattleCharacters.Struct.DataSet.get_skill ref.skill dataset)
   }

to_unresolved : Type -> Unresolved
to_unresolved equipment =
   {
      primary = (BattleCharacters.Struct.Weapon.get_id equipment.primary),
      secondary = (BattleCharacters.Struct.Weapon.get_id equipment.secondary),
      armor = (BattleCharacters.Struct.Armor.get_id equipment.armor),
      portrait = (BattleCharacters.Struct.Portrait.get_id equipment.portrait),
      glyph_board =
         (BattleCharacters.Struct.GlyphBoard.get_id equipment.glyph_board),
      glyphs =
         (Array.map (BattleCharacters.Struct.Glyph.get_id) equipment.glyphs),
      skill = (BattleCharacters.Struct.Skill.get_id equipment.skill)
   }

