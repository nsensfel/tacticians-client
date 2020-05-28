module Update.Puppeteer.ToggleCharacterEffect exposing (forward, backward)

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Battle
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
perform : (
      Int ->
      String ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
perform char_ix effect model =
   (
      {model |
         battle =
            (Struct.Battle.update_character
               char_ix
               (Struct.Character.toggle_extra_display_effect effect)
               model.battle
            )
      },
      []
   )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Int ->
      String ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward char_ix effect model =
   (perform char_ix effect model)


backward : (
      Int ->
      String ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward char_ix effect model =
   (perform char_ix effect model)
