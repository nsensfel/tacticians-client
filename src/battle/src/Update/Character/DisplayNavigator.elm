module Update.Character.DisplayNavigator exposing
   (
      apply_to_ref,
      apply_to_character
   )

-- Elm -------------------------------------------------------------------------
import Task

-- Local Module ----------------------------------------------------------------
import Action.Scroll

import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to_character : (
      Struct.Character.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to_character char model =
   (
      {model |
         ui =
            (Struct.UI.set_displayed_navigator
               (Util.Navigator.get_character_navigator model.battle char)
               model.ui
            )
      },
      (Task.attempt
         (Struct.Event.attempted)
         (Action.Scroll.to
            (Struct.Character.get_location char)
            model.ui
         )
      )
   )

apply_to_ref : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to_ref char_ix model =
   case (Struct.Battle.get_character char_ix model.battle) of
      (Just char) -> (apply_to_character char model)
      Nothing -> (model, Cmd.none)
