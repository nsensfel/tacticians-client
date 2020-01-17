module Update.EndTurn exposing (apply_to)

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
            {model |
               char_turn = (Struct.CharacterTurn.new),
               battle =
                  (Struct.Battle.update_character
                     (Struct.Character.get_index char)
                     (maybe_disable_char)
                     model.battle
                  )
            },
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
         (Struct.CharacterTurn.maybe_get_active_character
            model.char_turn
         ),
         (Struct.CharacterTurn.maybe_get_navigator model.char_turn)
      )
   of
      (
         Struct.CharacterTurn.MovedCharacter,
         (Just char),
         (Just nav)) ->
            (make_it_so model char nav)

      (
         Struct.CharacterTurn.ChoseTarget,
         (Just char),
         (Just nav)) ->
         (make_it_so model char nav)

      (
         Struct.CharacterTurn.SwitchedWeapons,
         (Just char),
         (Just nav)) ->
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
