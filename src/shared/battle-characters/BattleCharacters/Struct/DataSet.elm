module BattleCharacters.Struct.DataSet exposing
   (
      Type,
      new,
      is_ready,
      get_weapon,
      add_weapon,
      get_armor,
      add_armor,
      get_portrait,
      add_portrait,
      get_glyph,
      add_glyph,
      get_glyph_board,
      add_glyph_board,
      get_skill,
      add_skill
   )

-- Elm -------------------------------------------------------------------------
import Dict

-- Battle ----------------------------------------------------------------------
import BattleCharacters.Struct.Armor
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
      weapons :
         (Dict.Dict
            BattleCharacters.Struct.Weapon.Ref
            BattleCharacters.Struct.Weapon.Type
         ),
      armors :
         (Dict.Dict
            BattleCharacters.Struct.Armor.Ref
            BattleCharacters.Struct.Armor.Type
         ),
      glyphs :
         (Dict.Dict
            BattleCharacters.Struct.Glyph.Ref
            BattleCharacters.Struct.Glyph.Type
         ),
      glyph_boards :
         (Dict.Dict
            BattleCharacters.Struct.GlyphBoard.Ref
            BattleCharacters.Struct.GlyphBoard.Type
         ),
      portraits :
         (Dict.Dict
            BattleCharacters.Struct.Portrait.Ref
            BattleCharacters.Struct.Portrait.Type
         ),
      skills :
         (Dict.Dict
            BattleCharacters.Struct.Skill.Ref
            BattleCharacters.Struct.Skill.Type
         )
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Type
new =
   {
      weapons = (Dict.empty),
      armors = (Dict.empty),
      glyphs = (Dict.empty),
      glyph_boards = (Dict.empty),
      portraits = (Dict.empty),
      skills = (Dict.empty)
   }

is_ready : Type -> Bool
is_ready data_set =
   (
      (not (Dict.isEmpty data_set.portraits))
      && (not (Dict.isEmpty data_set.weapons))
      && (not (Dict.isEmpty data_set.armors))
      && (not (Dict.isEmpty data_set.glyph_boards))
      && (not (Dict.isEmpty data_set.glyphs))
      && (not (Dict.isEmpty data_set.skills))
   )

---- Accessors -----------------------------------------------------------------

----------------
---- Weapon ----
----------------
get_weapon : (
      BattleCharacters.Struct.Weapon.Ref ->
      Type ->
      BattleCharacters.Struct.Weapon.Type
   )
get_weapon wp_id data_set =
   case (Dict.get wp_id data_set.weapons) of
      (Just wp) -> wp
      Nothing -> BattleCharacters.Struct.Weapon.none

add_weapon : BattleCharacters.Struct.Weapon.Type -> Type -> Type
add_weapon wp data_set =
   {data_set |
      weapons =
         (Dict.insert
            (BattleCharacters.Struct.Weapon.get_id wp)
            wp
            data_set.weapons
         )
   }

---------------
---- Armor ----
---------------
get_armor : (
      BattleCharacters.Struct.Armor.Ref ->
      Type ->
      BattleCharacters.Struct.Armor.Type
   )
get_armor ar_id data_set =
   case (Dict.get ar_id data_set.armors) of
      (Just ar) -> ar
      Nothing -> BattleCharacters.Struct.Armor.none

add_armor : BattleCharacters.Struct.Armor.Type -> Type -> Type
add_armor ar data_set =
   {data_set |
      armors =
         (Dict.insert
            (BattleCharacters.Struct.Armor.get_id ar)
            ar
            data_set.armors
         )
   }

------------------
---- Portrait ----
------------------
get_portrait : (
      BattleCharacters.Struct.Portrait.Ref ->
      Type ->
      BattleCharacters.Struct.Portrait.Type
   )
get_portrait pt_id data_set =
   case (Dict.get pt_id data_set.portraits) of
      (Just pt) -> pt
      Nothing -> BattleCharacters.Struct.Portrait.none

add_portrait : BattleCharacters.Struct.Portrait.Type -> Type -> Type
add_portrait pt data_set =
   {data_set |
      portraits =
         (Dict.insert
            (BattleCharacters.Struct.Portrait.get_id pt)
            pt
            data_set.portraits
         )
   }

---------------
---- Glyph ----
---------------
get_glyph : (
      BattleCharacters.Struct.Glyph.Ref ->
      Type ->
      BattleCharacters.Struct.Glyph.Type
   )
get_glyph gl_id data_set =
   case (Dict.get gl_id data_set.glyphs) of
      (Just gl) -> gl
      Nothing -> BattleCharacters.Struct.Glyph.none

add_glyph : BattleCharacters.Struct.Glyph.Type -> Type -> Type
add_glyph gl data_set =
   {data_set |
      glyphs =
         (Dict.insert
            (BattleCharacters.Struct.Glyph.get_id gl)
            gl
            data_set.glyphs
         )
   }

---------------------
---- Glyph Board ----
---------------------
get_glyph_board : (
      BattleCharacters.Struct.GlyphBoard.Ref ->
      Type ->
      BattleCharacters.Struct.GlyphBoard.Type
   )
get_glyph_board gb_id data_set =
   case (Dict.get gb_id data_set.glyph_boards) of
      (Just gb) -> gb
      Nothing -> BattleCharacters.Struct.GlyphBoard.none

add_glyph_board : BattleCharacters.Struct.GlyphBoard.Type -> Type -> Type
add_glyph_board glb data_set =
   {data_set |
      glyph_boards =
         (Dict.insert
            (BattleCharacters.Struct.GlyphBoard.get_id glb)
            glb
            data_set.glyph_boards
         )
   }

---------------
---- Skill ----
---------------
get_skill : (
      BattleCharacters.Struct.Skill.Ref ->
      Type ->
      BattleCharacters.Struct.Skill.Type
   )
get_skill sk_id data_set =
   case (Dict.get sk_id data_set.skills) of
      (Just sk) -> sk
      Nothing -> BattleCharacters.Struct.Skill.none

add_skill : BattleCharacters.Struct.Skill.Type -> Type -> Type
add_skill sk data_set =
   {data_set |
      skills =
         (Dict.insert
            (BattleCharacters.Struct.Skill.get_id sk)
            sk
            data_set.skills
         )
   }

