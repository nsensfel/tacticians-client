module Struct.Model exposing
   (
      Type,
      new,
      add_unresolved_character,
      resolve_all_characters,
      update_character,
      update_character_fun,
      save_character,
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
      error : (Maybe Struct.Error.Type),
      ui : Struct.UI.Type
      help_request : Struct.HelpRequest.Type,
      edited_char : (Maybe Struct.Character.Type),

      roster_id : String,
      battle_order : (Array.Array Int),

      characters : (Array.Array Struct.Character.Type),
      unresolved_characters : (List Struct.Character.Unresolved),
      inventory : Struct.Inventory.Type,

      characters_data_set : BattleCharacters.Struct.DataSet.Type,
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
add_character_from_unresolved : Struct.Character.Unresolved -> Type -> Type
add_character_from_unresolved char_ref model =
   let
      char =
         (Struct.Character.resolve
            (BattleCharacters.Struct.Equipment.resolve model.inventory)
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
      || (BattleCharacters.Struct.DataSet.is_ready model.characters_data_set)
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
      inventory = (BattleCharacters.Struct.Inventory.new),
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
