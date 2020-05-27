module Update.CharacterTurn.UnlockPath exposing (apply_to)

-- Local Module ----------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   case (Struct.CharacterTurn.maybe_get_navigator model.char_turn) of
      (Just nav) ->
         (
            {model |
               char_turn =
                  (Struct.CharacterTurn.set_navigator
                     (Struct.Navigator.unlock_path nav)
                     (Struct.CharacterTurn.clear_path model.char_turn)
                  )
            },
            Cmd.none
         )

      _ ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new
                  Struct.Error.IllegalAction
                  "This can only be done while controlling a character."
               )
               model
            ),
            Cmd.none
         )
