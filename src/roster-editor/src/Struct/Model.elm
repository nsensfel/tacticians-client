module Struct.Model exposing
   (
      Type,
      new,
      add_unresolved_character,
      resolve_all_characters,
      update_character,
      update_character_fun,
      save_character,
      add_weapon,
      add_armor,
      add_portrait,
      add_glyph,
      add_glyph_board,
      invalidate,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Array

import List

import Dict

-- Shared ----------------------------------------------------------------------
import Struct.Flags

import Util.Array

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Weapon
import BattleCharacters.Struct.Glyph
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.GlyphBoard

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Error
import Struct.HelpRequest
import Struct.Inventory
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      flags : Struct.Flags.Type,
      help_request : Struct.HelpRequest.Type,
      characters : (Array.Array Struct.Character.Type),
      unresolved_characters : (List Struct.Character.Unresolved),
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
      error : (Maybe Struct.Error.Type),
      battle_order : (Array.Array Int),
      player_id : String,
      roster_id : String,
      edited_char : (Maybe Struct.Character.Type),
      inventory : Struct.Inventory.Type,
      session_token : String,
      ui : Struct.UI.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
add_character_from_unresolved : Struct.Character.Unresolved -> Type -> Type
add_character_from_unresolved char_ref model =
   let
      char =
         (Struct.Character.resolve
            (BattleCharacters.Struct.Equipment.resolve
               (BattleCharacters.Struct.Weapon.find model.weapons)
               (BattleCharacters.Struct.Armor.find model.armors)
               (BattleCharacters.Struct.Portrait.find model.portraits)
               (BattleCharacters.Struct.GlyphBoard.find model.glyph_boards)
               (BattleCharacters.Struct.Glyph.find model.glyphs)
            )
            char_ref
         )
   in
      {model |
         characters =
            (Array.push
--               (Struct.Character.get_index char)
               char
               model.characters
            )
      }

has_loaded_data : Type -> Bool
has_loaded_data model =
   (
      ((Array.length model.characters) > 0)
      ||
      (
         (model.portraits /= (Dict.empty))
         && (model.weapons /= (Dict.empty))
         && (model.armors /= (Dict.empty))
         && (model.glyph_boards /= (Dict.empty))
         && (model.glyphs /= (Dict.empty))
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Struct.Flags.Type -> Type
new flags =
   {
      flags = flags,
      help_request = Struct.HelpRequest.None,
      characters = (Array.empty),
      unresolved_characters = [],
      weapons = (Dict.empty),
      armors = (Dict.empty),
      glyphs = (Dict.empty),
      glyph_boards = (Dict.empty),
      portraits = (Dict.empty),
      error = Nothing,
      roster_id = "",
      player_id =
         (
            if (flags.user_id == "")
            then "0"
            else flags.user_id
         ),
      battle_order =
         (Array.repeat
            (
               case (Struct.Flags.maybe_get_param "s" flags) of
                  Nothing -> 0
                  (Just "s") -> 8
                  (Just "m") -> 16
                  (Just "l") -> 24
                  (Just _) -> 0
            )
            -1
         ),
      session_token = flags.token,
      edited_char = Nothing,
      inventory = (Struct.Inventory.empty),
      ui = (Struct.UI.default)
   }

add_unresolved_character : Struct.Character.Unresolved -> Type -> Type
add_unresolved_character char_ref model =
   if (has_loaded_data model)
   then
      (add_character_from_unresolved char_ref model)
   else
      {model |
         unresolved_characters = (char_ref :: model.unresolved_characters)
      }

resolve_all_characters : Type -> Type
resolve_all_characters model =
   if (has_loaded_data model)
   then
      (List.foldr
         (add_character_from_unresolved)
         {model | unresolved_characters = []}
         model.unresolved_characters
      )
   else
      model

add_weapon : BattleCharacters.Struct.Weapon.Type -> Type -> Type
add_weapon wp model =
   {model |
      weapons =
         (Dict.insert
            (BattleCharacters.Struct.Weapon.get_id wp)
            wp
            model.weapons
         )
   }

add_armor : BattleCharacters.Struct.Armor.Type -> Type -> Type
add_armor ar model =
   {model |
      armors =
         (Dict.insert
            (BattleCharacters.Struct.Armor.get_id ar)
            ar
            model.armors
         )
   }

add_portrait : BattleCharacters.Struct.Portrait.Type -> Type -> Type
add_portrait pt model =
   {model |
      portraits =
         (Dict.insert
            (BattleCharacters.Struct.Portrait.get_id pt)
            pt
            model.portraits
         )
   }

add_glyph : BattleCharacters.Struct.Glyph.Type -> Type -> Type
add_glyph gl model =
   {model |
      glyphs =
         (Dict.insert
            (BattleCharacters.Struct.Glyph.get_id gl)
            gl
            model.glyphs
         )
   }

add_glyph_board : BattleCharacters.Struct.GlyphBoard.Type -> Type -> Type
add_glyph_board glb model =
   {model |
      glyph_boards =
         (Dict.insert
            (BattleCharacters.Struct.GlyphBoard.get_id glb)
            glb
            model.glyph_boards
         )
   }

update_character : Int -> Struct.Character.Type -> Type -> Type
update_character ix new_val model =
   {model |
      characters = (Array.set ix new_val model.characters)
   }

save_character : Type -> Type
save_character model =
   case model.edited_char of
      Nothing -> model

      (Just char) ->
         {model |
            characters =
               (Array.set
                  (Struct.Character.get_index char)
                  (Struct.Character.set_is_valid
                     (Struct.Character.set_was_edited True char)
                  )
                  model.characters
               )
         }

update_character_fun : (
      Int ->
      ((Maybe Struct.Character.Type) -> (Maybe Struct.Character.Type)) ->
      Type ->
      Type
   )
update_character_fun ix fun model =
   {model |
      characters = (Util.Array.update ix (fun) model.characters)
   }

invalidate : Struct.Error.Type -> Type -> Type
invalidate err model =
   {model |
      error = (Just err)
   }

clear_error : Type -> Type
clear_error model = {model | error = Nothing}
