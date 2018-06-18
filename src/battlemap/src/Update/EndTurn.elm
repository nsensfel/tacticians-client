module Update.EndTurn exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Struct.Battlemap -------------------------------------------------------------------
import Comm.CharacterTurn

import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Navigator.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
make_it_so model char nav =
   case (Comm.CharacterTurn.try model) of
      (Just cmd) ->
         (
            (Struct.Model.reset
               (Struct.Model.update_character
                  (Struct.Character.get_index char)
                  (Struct.Character.set_enabled
                     False
                     (Struct.Character.set_location
                        (Struct.Navigator.get_current_location nav)
                        char
                     )
                  )
                  model
               )
            ),
            cmd
         )

      Nothing ->
         (model, Cmd.none)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   case
      (
         (Struct.CharacterTurn.get_state model.char_turn),
         (Struct.CharacterTurn.try_getting_active_character
            model.char_turn
         ),
         (Struct.CharacterTurn.try_getting_navigator model.char_turn)
      )
   of
      (
         Struct.CharacterTurn.MovedCharacter,
         (Just char),
         (Just nav)
      ) ->
         (make_it_so model char nav)

      (
         Struct.CharacterTurn.ChoseTarget,
         (Just char),
         (Just nav)
      ) ->
         (make_it_so model char nav)

      (Struct.CharacterTurn.SelectedCharacter, (Just char), (Just nav)) ->
         (make_it_so model char nav)

      (_, _, _) ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new
                  Struct.Error.Programming
                  "Character turn appears to be in an illegal state."
               )
               model
            ),
            Cmd.none
         )
