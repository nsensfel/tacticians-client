module Update.CharacterTurn.EndTurn exposing (apply_to)

-- Local Module ----------------------------------------------------------------
import Comm.CharacterTurn

import Constants.DisplayEffects

import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator

import Update.CharacterTurn.AbortTurn

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   case
      (
         (Struct.CharacterTurn.maybe_get_active_character model.char_turn),
         (Comm.CharacterTurn.try model)
      )
   of
      (Nothing, _) -> (model, Cmd.none)
      (_, Nothing) -> (model, Cmd.none)
      ((Just char), (Just cmd)) ->
         (
            (Update.CharacterTurn.AbortTurn.no_command_apply_to
               {model |
                  battle =
                     (Struct.Battle.update_character
                        (Struct.Character.get_index char)
                        (
                           (Struct.Character.remove_extra_display_effect
                              Constants.DisplayEffects.enabled_character
                           )
                           >>
                           (Struct.Character.set_enabled False)
                        )
                        model.battle
                     )
               }
            ),
            cmd
         )
