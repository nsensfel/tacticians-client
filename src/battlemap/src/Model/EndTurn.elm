module Model.EndTurn exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Battlemap

import Character

import Error
import Event

import Model

import Send.CharacterTurn
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : Model.Type -> (Model.Type, (Cmd Event.Type))
make_it_so model =
   case (Battlemap.try_getting_navigator_location model.battlemap) of
      (Just location) ->
         case (Send.CharacterTurn.try model) of
            (Just cmd) ->
               (
                  (Model.reset
                     model
                     (Dict.update
                        char_ref
                        (\maybe_char ->
                           case maybe_char of
                              (Just char) ->
                                 (Just
                                    (Character.set_enabled
                                       (Character.set_location location char)
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

      Nothing ->
         (
            (Model.invalidate
               model
               (Error.new
                  Error.Programming
                  "EndTurn: model moving char, no navigator location."
               )
            ),
            Cmd.none
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Model.Type -> (Model.Type, (Cmd Event.Type))
apply_to model =
   case (Query.CharacterTurn.get_state model.char_turn) of
      Query.CharacterTurn.MovedCharacter -> (make_it_so model)
      Query.CharacterTurn.ChoseTarget -> (make_it_so model)

      _ ->
         (
            (Model.invalidate
               model
               (Error.new
                  Error.IllegalAction
                  "This can only be done while moving a character."
               )
            ),
            Cmd.none
         )
