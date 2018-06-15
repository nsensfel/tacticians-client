module Update.DisplayCharacterInfo exposing (apply_to)
-- Elm -------------------------------------------------------------------------
import Array
import Task

-- Battlemap -------------------------------------------------------------------
import Action.Scroll

import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
scroll_to_char : Struct.Model.Type -> Int -> (Cmd Struct.Event.Type)
scroll_to_char model char_ix =
   case (Array.get char_ix model.characters) of
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
      Struct.Model.Type ->
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model target_ref =
   (
      {model |
         ui =
            (Struct.UI.set_displayed_tab
               Struct.UI.StatusTab
               (Struct.UI.set_previous_action
                  (Just (Struct.UI.SelectedCharacter target_ref))
                  model.ui
               )
            )
      },
      (scroll_to_char model target_ref)
   )
