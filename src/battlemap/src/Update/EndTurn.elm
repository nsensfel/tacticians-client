module Update.EndTurn exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Struct.Battlemap -------------------------------------------------------------------
import Send.CharacterTurn

import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
make_it_so model =
   case -- (Struct.Battlemap.try_getting_navigator_location model.battlemap) of
      (Just {x = 0, y = 0})
   of
      (Just location) ->
         case (Send.CharacterTurn.try model) of
            (Just cmd) ->
               (
                  (Struct.Model.reset
                     model
                     (Dict.update
                        "0" --char_ref
                        (\maybe_char ->
                           case maybe_char of
                              (Just char) ->
                                 (Just
                                    (Struct.Character.set_enabled
                                       (Struct.Character.set_location
                                          location
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

      Nothing ->
         (
            (Struct.Model.invalidate
               model
               (Struct.Error.new
                  Struct.Error.Programming
                  "EndTurn: model moving char, no navigator location."
               )
            ),
            Cmd.none
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   case (Struct.CharacterTurn.get_state model.char_turn) of
      Struct.CharacterTurn.MovedCharacter -> (make_it_so model)
      Struct.CharacterTurn.ChoseTarget -> (make_it_so model)

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
