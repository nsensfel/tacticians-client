module Update.EndTurn exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Struct.Battlemap -------------------------------------------------------------------
import Send.CharacterTurn

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
   case (Send.CharacterTurn.try model) of
      (Just cmd) ->
         (
            (Struct.Model.reset
               model
               (Dict.update
                  (Struct.Character.get_ref char)
                  (\maybe_char ->
                     case maybe_char of
                        (Just char) ->
                           (Just
                              (Struct.Character.set_enabled
                                 (Struct.Character.set_location
                                    (Struct.Navigator.get_current_location nav)
                                    char
                                 )
                                 False
                              )
                           )
                        Nothing -> Nothing
                  )
                  model.characters
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

      (_, _, _) ->
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
