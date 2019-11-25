module BattleCharacters.Struct.DataSetItem exposing (Type(..), add_to)

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
type Type =
   Armor BattleCharacters.Struct.Armor.Type
   | Glyph BattleCharacters.Struct.Glyph.Type
   | GlyphBoard BattleCharacters.Struct.GlyphBoard.Type
   | Portrait BattleCharacters.Struct.Portrait.Type
   | Skill BattleCharacters.Struct.Skill.Type
   | Weapon BattleCharacters.Struct.Weapon.Type

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
add_to : (
      Type ->
      BattleCharacters.Struct.DataSet.Type ->
      BattleCharacters.Struct.DataSet.Type
   )
add_to item dataset =
   case item of
      (Armor ar) -> (BattleCharacters.Struct.DataSet.add_armor ar dataset)
      (Glyph gl) -> (BattleCharacters.Struct.DataSet.add_glyph gl dataset)
      (Portrait pt) -> (BattleCharacters.Struct.DataSet.add_portrait pt dataset)
      (Skill sk) -> (BattleCharacters.Struct.DataSet.add_skill sk dataset)
      (Weapon wp) -> (BattleCharacters.Struct.DataSet.add_weapon wp dataset)
      (GlyphBoard gb) ->
         (BattleCharacters.Struct.DataSet.add_glyph_board gb dataset)

