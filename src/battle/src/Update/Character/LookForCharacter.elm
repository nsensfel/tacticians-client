module Update.Character.LookForCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array
import Task

-- Local Module ----------------------------------------------------------------
import Action.Scroll

import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
scroll_to_char : Struct.Model.Type -> Int -> (Cmd Struct.Event.Type)
scroll_to_char model char_ix =
   case (Struct.Battle.get_character char_ix model.battle) of
      (Just char) ->
         (Task.attempt
            (Struct.Event.attempted)
            (Action.Scroll.to
               (Struct.Character.get_location char)
               model.ui
            )
         )

      Nothing ->
         Cmd.none

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to target_ix model =
   (
      {model |
         ui =
            (Struct.UI.set_previous_action
               (Just (Struct.UI.SelectedCharacter target_ix))
               model.ui
            )
      },
      (scroll_to_char model target_ix)
   )
