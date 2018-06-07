module Struct.Model exposing
   (
      Type,
      new,
      add_character,
      add_weapon,
      add_armor,
      invalidate,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Dict
import Array

-- Battlemap -------------------------------------------------------------------
import Struct.Armor
import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.TurnResult
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
      armors: (Dict.Dict Struct.Armor.Ref Struct.Armor.Type),
      error: (Maybe Struct.Error.Type),
      player_id: String,
      ui: Struct.UI.Type,
      char_turn: Struct.CharacterTurn.Type,
      timeline: (Array.Array Struct.TurnResult.Type)
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
      weapons = (Dict.empty),
      armors = (Dict.empty),
      error = Nothing,
      player_id = "0",
      ui = (Struct.UI.default),
      char_turn = (Struct.CharacterTurn.new),
      timeline = (Array.empty)
   }

add_character : Struct.Character.Type -> Type -> Type
add_character char model =
   {model |
      characters =
         (Dict.insert
            (Struct.Character.get_ref char)
            char
            model.characters
         )
   }

add_weapon : Struct.Weapon.Type -> Type -> Type
add_weapon wp model =
   {model |
      weapons =
         (Dict.insert
            (Struct.Weapon.get_id wp)
            wp
            model.weapons
         )
   }

add_armor : Struct.Armor.Type -> Type -> Type
add_armor ar model =
   {model |
      armors =
         (Dict.insert
            (Struct.Armor.get_id ar)
            ar
            model.armors
         )
   }

reset : (Dict.Dict Struct.Character.Ref Struct.Character.Type) -> Type -> Type
reset characters model =
   {model |
      characters = characters,
      error = Nothing,
      ui = (Struct.UI.set_previous_action Nothing model.ui),
      char_turn = (Struct.CharacterTurn.new)
   }

invalidate : Struct.Error.Type -> Type -> Type
invalidate err model =
   {model |
      error = (Just err),
      ui = (Struct.UI.set_displayed_tab Struct.UI.StatusTab model.ui)
   }

clear_error : Type -> Type
clear_error model = {model | error = Nothing}
