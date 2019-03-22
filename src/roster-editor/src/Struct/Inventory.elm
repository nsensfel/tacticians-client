module Struct.Inventory exposing
   (
      Type,
      has_portrait,
      has_glyph,
      has_glyph_board,
      has_weapon,
      has_armor,
      allows,
      empty,
      decoder
   )

-- Elm -------------------------------------------------------------------------
import Array

import Json.Decode
import Json.Decode.Pipeline

import Set

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.GlyphBoard
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      portraits : (Set.Set BattleCharacters.Struct.Portrait.Ref),
      glyphs : (Set.Set BattleCharacters.Struct.Glyph.Ref),
      glyph_boards : (Set.Set BattleCharacters.Struct.GlyphBoard.Ref),
      weapons : (Set.Set BattleCharacters.Struct.Weapon.Ref),
      armors : (Set.Set BattleCharacters.Struct.Armor.Ref)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
has_portrait : Type -> BattleCharacters.Struct.Portrait.Ref -> Bool
has_portrait inv id = (Set.member id inv.portraits)

has_glyph : Type -> BattleCharacters.Struct.Glyph.Ref -> Bool
has_glyph inv id = (Set.member id inv.glyphs)

has_glyph_board : Type -> BattleCharacters.Struct.GlyphBoard.Ref -> Bool
has_glyph_board inv id = (Set.member id inv.glyph_boards)

has_weapon : Type -> BattleCharacters.Struct.Weapon.Ref -> Bool
has_weapon inv id = (Set.member id inv.weapons)

has_armor : Type -> BattleCharacters.Struct.Armor.Ref -> Bool
has_armor inv id = (Set.member id inv.armors)

allows : Type -> BattleCharacters.Struct.Equipment.Type -> Bool
allows inv equipment =
   (and
      (has_weapon
         inv
         (BattleCharacters.Struct.Weapon.get_id
            (BattleCharacters.Struct.Equipment.get_primary_weapon equipment)
         )
      )
      (has_weapon
         inv
         (BattleCharacters.Struct.Weapon.get_id
            (BattleCharacters.Struct.Equipment.get_secondary_weapon equipment)
         )
      )
      (has_armor
         inv
         (BattleCharacters.Struct.Armor.get_id
            (BattleCharacters.Struct.Equipment.get_armor equipment)
         )
      )
      (has_portrait
         inv
         (BattleCharacters.Struct.Portrait.get_id
            (BattleCharacters.Struct.Equipment.get_portrait equipment)
         )
      )
      (has_glyph_board
         inv
         (BattleCharacters.Struct.GlyphBoard.get_id
            (BattleCharacters.Struct.Equipment.get_glyph_board equipment)
         )
      )
      (List.all
         ((BattleCharacters.Struct.Glyph.get_id) |> (has_glyph inv))
         (Array.toList (BattleCharacters.Struct.Equipment.get_glyphs equipment))
      )
   )

empty : Type
empty =
   {
      portraits = (Set.empty),
      glyphs = (Set.empty),
      glyph_boards = (Set.empty),
      weapons = (Set.empty),
      armors = (Set.empty)
   }

decoder : (Json.Decode.Decoder Type)
decoder =
   -- TODO
   (Json.Decode.succeed
      Type
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
   )
