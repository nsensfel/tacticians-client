module Struct.Model exposing
   (
      Type,
      new,
      add_character,
      update_character,
      update_character_fun,
      add_weapon,
      add_armor,
      invalidate,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

-- Map -------------------------------------------------------------------
import Struct.Armor
import Struct.Map
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Flags
import Struct.HelpRequest
import Struct.Tile
import Struct.TurnResult
import Struct.TurnResultAnimator
import Struct.UI
import Struct.Weapon

import Util.Array

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      help_request: Struct.HelpRequest.Type,
      characters: (Array.Array Struct.Character.Type),
      weapons: (Dict.Dict Struct.Weapon.Ref Struct.Weapon.Type),
      armors: (Dict.Dict Struct.Armor.Ref Struct.Armor.Type),
      error: (Maybe Struct.Error.Type),
      player_id: String,
      session_token: String,
      ui: Struct.UI.Type
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Struct.Flags.Type -> Type
new flags =
   {
      help_request = Struct.HelpRequest.None,
      characters = (Array.empty),
      weapons = (Dict.empty),
      armors = (Dict.empty),
      error = Nothing,
      player_id =
         (
            if (flags.user_id == "")
            then "0"
            else flags.user_id
         ),
      session_token = flags.token,
      ui = (Struct.UI.default)
   }

add_character : Struct.Character.Type -> Type -> Type
add_character char model =
   {model |
      characters =
         (Array.push
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

reset : Type -> Type
reset model =
   {model |
      help_request = Struct.HelpRequest.None,
      error = Nothing,
      ui = (Struct.UI.set_previous_action Nothing model.ui)
   }

update_character : Int -> Struct.Character.Type -> Type -> Type
update_character ix new_val model =
   {model |
      characters = (Array.set ix new_val model.characters)
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
