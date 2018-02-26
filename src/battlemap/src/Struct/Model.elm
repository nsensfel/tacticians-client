module Struct.Model exposing
   (
      Type,
      new,
      add_character,
      invalidate,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Data.Weapons

import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.UI
import Struct.Weapon

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      battlemap: Struct.Battlemap.Type,
      characters: (Dict.Dict Struct.Character.Ref Struct.Character.Type),
      weapons: (Dict.Dict Struct.Weapon.Ref Struct.Weapon.Type),
      error: (Maybe Struct.Error.Type),
      player_id: String,
      ui: Struct.UI.Type,
      char_turn: Struct.CharacterTurn.Type
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
      battlemap = (Struct.Battlemap.empty),
      characters = (Dict.empty),
      weapons = (Data.Weapons.generate_dict),
      error = Nothing,
      player_id = "0",
      ui = (Struct.UI.default),
      char_turn = (Struct.CharacterTurn.new)
   }

add_character : Type -> Struct.Character.Type -> Type
add_character model char =
   {model |
      characters =
         (Dict.insert
            (Struct.Character.get_ref char)
            char
            model.characters
         )
   }

reset : Type -> (Dict.Dict Struct.Character.Ref Struct.Character.Type) -> Type
reset model characters =
   {model |
      characters = characters,
      error = Nothing,
      ui = (Struct.UI.set_previous_action model.ui Nothing),
      char_turn = (Struct.CharacterTurn.new)
   }

invalidate : Type -> Struct.Error.Type -> Type
invalidate model err =
   {model |
      error = (Just err),
      ui = (Struct.UI.set_displayed_tab model.ui Struct.UI.StatusTab)
   }

clear_error : Type -> Type
clear_error model = {model | error = Nothing}
