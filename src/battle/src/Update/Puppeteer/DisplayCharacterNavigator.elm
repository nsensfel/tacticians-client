module Update.Puppeteer.DisplayCharacterNavigator exposing
   (
      forward,
      backward
   )

-- Elm -------------------------------------------------------------------------
import Task

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
display_character_navigator : (
      Struct.Character.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
display_character_navigator char model =
   (
      {model |
         ui =
            (Struct.UI.set_displayed_navigator
               (Util.Navigator.get_character_attack_navigator
                  model.battle
                  char
               )
               model.ui
            )
      },
      []
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward char_ix model =
   case (Struct.Battle.get_character char_ix model.battle) of
      (Just char) -> (display_character_navigator char model)
      Nothing ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new
                  Struct.Error.Programming
                  "Puppeteer tried displaying navigator of unknown character."
               )
               model
            ),
            []
         )

backward : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward char_ix model =
   ({model | ui = (Struct.UI.clear_displayed_navigator model.ui)}, [])
