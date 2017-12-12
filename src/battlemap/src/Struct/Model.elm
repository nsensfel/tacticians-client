module Struct.Model exposing
   (
      Type,
      add_character,
      invalidate,
      reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Location
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      battlemap: Struct.Battlemap.Type,
      characters: (Dict.Dict Struct.Character.Ref Struct.Character.Type),
      error: (Maybe Struct.Error.Type),
      controlled_team: Int,
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
