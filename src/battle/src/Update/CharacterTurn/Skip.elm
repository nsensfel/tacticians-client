module Update.CharacterTurn.Skip exposing (apply_to)

-- Shared ----------------------------------------------------------------------
import Shared.Update.Sequence

-- Local module ----------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator

import Update.CharacterTurn.ResetPath

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
set_action : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
set_action model =
   (
      {model |
         char_turn =
            (Struct.CharacterTurn.set_action
               Struct.CharacterTurn.Skipping
               model.char_turn
            )
      },
      Cmd.none
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (Shared.Update.Sequence.sequence
      [
         (Update.CharacterTurn.ResetPath.apply_to),
         (set_action)
      ]
      model
   )
