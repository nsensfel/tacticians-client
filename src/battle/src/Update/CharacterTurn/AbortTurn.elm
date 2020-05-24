module Update.CharacterTurn.AbortTurn exposing (apply_to)

-- Local Module ----------------------------------------------------------------
import Constants.DisplayEffects

import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (
      {model |
         char_turn = (Struct.CharacterTurn.new),
         battle =
            case
               (Struct.CharacterTurn.maybe_get_active_character model.char_turn)
            of
               Nothing -> model.battle
               (Just char) ->
                  (Struct.Battle.update_character
                     (Struct.Character.get_index char)
                     (Struct.Character.remove_extra_display_effect
                        Constants.DisplayEffects.active_character
                     )
                     model.battle
                  )
      },
      Cmd.none
   )
