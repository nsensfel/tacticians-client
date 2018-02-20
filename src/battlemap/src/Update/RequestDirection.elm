module Update.RequestDirection exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Direction
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : (
      Struct.Model.Type ->
      Struct.Navigator.Type ->
      Struct.Direction.Type ->
      Struct.Model.Type
   )
make_it_so model navigator dir =
   case (Struct.Navigator.try_adding_step navigator dir) of
      (Just new_navigator) ->
         {model |
            char_turn =
               (Struct.CharacterTurn.set_navigator
                  new_navigator
                  model.char_turn
               ),
            ui =
               (Struct.UI.set_previous_action
                  model.ui
                  (Just Struct.UI.UsedManualControls)
               )
         }

      Nothing ->
         (Struct.Model.invalidate
            model
            (Struct.Error.new
               Struct.Error.IllegalAction
               "Unreachable/occupied tile."
            )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Direction.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model dir =
   case
      (Struct.CharacterTurn.try_getting_navigator model.char_turn)
   of
      (Just navigator) ->
         (
            (make_it_so model navigator dir),
            Cmd.none
         )

      _ ->
         (
            (Struct.Model.invalidate
               model
               (Struct.Error.new
                  Struct.Error.IllegalAction
                  "This can only be done while moving a character."
               )
            ),
            Cmd.none
         )
