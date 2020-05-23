module Update.CharacterTurn.Attack exposing (apply_to)

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
      Nothing -> (model, Cmd.none)
      (Just nav) ->
         (
            {model |
               char_turn =
                  (Struct.CharacterTurn.set_action
                     Struct.CharacterTurn.Attacking
                     (Struct.CharacterTurn.set_navigator
                        (Struct.Navigator.lock_path nav)
                        (Struct.CharacterTurn.store_path model.char_turn)
                     )
                  )
            },
            Cmd.none
         )
