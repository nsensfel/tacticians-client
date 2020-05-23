module Update.CharacterTurn.EndTurn exposing (apply_to)

-- Local Module ----------------------------------------------------------------
import Comm.CharacterTurn

import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
maybe_disable_char : (
      (Maybe Struct.Character.Type) ->
      (Maybe Struct.Character.Type)
   )
maybe_disable_char maybe_char =
   case maybe_char of
      (Just char) -> (Just (Struct.Character.set_enabled False char))
      Nothing -> Nothing

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
            {model |
               battle =
                  (Struct.Battle.update_character
                     (Struct.Character.get_index char)
                     (maybe_disable_char)
                     model.battle
                  ),
               char_turn = (Struct.CharacterTurn.new)
            },
            cmd
         )
