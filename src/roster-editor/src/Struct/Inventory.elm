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
import BattleCharacters.Struct.Skill
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
      armors : (Set.Set BattleCharacters.Struct.Armor.Ref),
      skills : (Set.Set BattleCharacters.Struct.Skill.Ref)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
has_portrait : BattleCharacters.Struct.Portrait.Ref -> Type -> Bool
has_portrait id inv = (Set.member id inv.portraits)

has_glyph : BattleCharacters.Struct.Glyph.Ref -> Type -> Bool
has_glyph id inv = (Set.member id inv.glyphs)

has_glyph_board : BattleCharacters.Struct.GlyphBoard.Ref -> Type -> Bool
has_glyph_board id inv = (Set.member id inv.glyph_boards)

has_weapon : BattleCharacters.Struct.Weapon.Ref -> Type -> Bool
has_weapon id inv = (Set.member id inv.weapons)

has_armor : BattleCharacters.Struct.Armor.Ref -> Type -> Bool
has_armor id inv = (Set.member id inv.armors)

has_skill : BattleCharacters.Struct.Skill.Ref -> Type -> Bool
has_skill id inv = (Set.member id inv.skills)

allows : BattleCharacters.Struct.Equipment.Type -> Type -> Bool
allows equipment inv =
   (
      (has_weapon
         (BattleCharacters.Struct.Weapon.get_id
            (BattleCharacters.Struct.Equipment.get_primary_weapon equipment)
         )
         inv
      )
      &&
      (has_weapon
         (BattleCharacters.Struct.Weapon.get_id
            (BattleCharacters.Struct.Equipment.get_secondary_weapon equipment)
         )
         inv
      )
      &&
      (has_armor
         (BattleCharacters.Struct.Armor.get_id
            (BattleCharacters.Struct.Equipment.get_armor equipment)
         )
         inv
      )
      &&
      (has_portrait
         (BattleCharacters.Struct.Portrait.get_id
            (BattleCharacters.Struct.Equipment.get_portrait equipment)
         )
         inv
      )
      &&
      (has_glyph_board
         (BattleCharacters.Struct.GlyphBoard.get_id
            (BattleCharacters.Struct.Equipment.get_glyph_board equipment)
         )
         inv
      )
      &&
      (List.all
         (\e -> (has_glyph e inv))
         (Array.toList (BattleCharacters.Struct.Equipment.get_glyphs equipment))
      )
      &&
      (has_skill
         (BattleCharacters.Struct.Skill.get_id
            (BattleCharacters.Struct.Equipment.get_skill equipment)
         )
         inv
      )
   )

empty : Type
empty =
   {
      portraits = (Set.empty),
      glyphs = (Set.empty),
      glyph_boards = (Set.empty),
      weapons = (Set.empty),
      armors = (Set.empty),
      skills = (Set.empty)
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
      |> (Json.Decode.Pipeline.hardcoded (Set.empty))
   )
