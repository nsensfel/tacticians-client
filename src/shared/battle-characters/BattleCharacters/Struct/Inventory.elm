module BattleCharacters.Struct.Inventory exposing
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
            BattleCharacters.Struct.Portrait.Ref
            BattleCharacters.Struct.Portrait.Type
         ),
   }

is_ready : Type -> Bool
is_ready inventory =
   (
      (inventory.portraits /= (Dict.empty))
      && (inventory.weapons /= (Dict.empty))
      && (inventory.armors /= (Dict.empty))
      && (inventory.glyph_boards /= (Dict.empty))
      && (inventory.glyphs /= (Dict.empty))
      && (inventory.skills /= (Dict.empty))
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
get_weapon wp_id inventory =
   case (Dict.get wp_id inventory.weapons) of
      (Just wp) -> wp
      Nothing -> BattleCharacters.Struct.Weapon.none

add_weapon : BattleCharacters.Struct.Weapon.Type -> Type -> Type
add_weapon wp inventory =
   {inventory |
      weapons =
         (Dict.insert
            (BattleCharacters.Struct.Weapon.get_id wp)
            wp
            inventory.weapons
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
get_armor ar_id inventory =
   case (Dict.get ar_id inventory.armors) of
      (Just ar) -> ar
      Nothing -> BattleCharacters.Struct.Armor.none

add_armor : BattleCharacters.Struct.Armor.Type -> Type -> Type
add_armor ar inventory =
   {inventory |
      armors =
         (Dict.insert
            (BattleCharacters.Struct.Armor.get_id ar)
            ar
            inventory.armors
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
get_portrait pt_id inventory =
   case (Dict.get pt_id inventory.portraits) of
      (Just pt) -> pt
      Nothing -> BattleCharacters.Struct.Portrait.none

add_portrait : BattleCharacters.Struct.Portrait.Type -> Type -> Type
add_portrait pt inventory =
   {inventory |
      portraits =
         (Dict.insert
            (BattleCharacters.Struct.Portrait.get_id pt)
            pt
            inventory.portraits
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
get_glyph gl_id inventory =
   case (Dict.get gl_id inventory.glyphs) of
      (Just gl) -> gl
      Nothing -> BattleCharacters.Struct.Glyph.none

add_glyph : BattleCharacters.Struct.Glyph.Type -> Type -> Type
add_glyph gl inventory =
   {inventory |
      glyphs =
         (Dict.insert
            (BattleCharacters.Struct.Glyph.get_id gl)
            gl
            inventory.glyphs
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
get_glyph_board gb_id inventory =
   case (Dict.get gb_id inventory.glyph_boards) of
      (Just gb) -> gb
      Nothing -> BattleCharacters.Struct.GlyphBoard.none

add_glyph_board : BattleCharacters.Struct.GlyphBoard.Type -> Type -> Type
add_glyph_board glb inventory =
   {inventory |
      glyph_boards =
         (Dict.insert
            (BattleCharacters.Struct.GlyphBoard.get_id glb)
            glb
            inventory.glyph_boards
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
get_skill sk_id inventory =
   case (Dict.get sk_id inventory.skills) of
      (Just sk) -> sk
      Nothing -> BattleCharacters.Struct.Skill.none

add_skill : BattleCharacters.Struct.Skill.Type -> Type -> Type
add_skill sk inventory =
   {inventory |
      skills =
         (Dict.insert
            (BattleCharacters.Struct.Skill.get_id sk)
            sk
            inventory.skills
         )
   }

