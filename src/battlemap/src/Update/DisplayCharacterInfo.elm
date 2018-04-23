module Update.DisplayCharacterInfo exposing (apply_to)
-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
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
      Cmd.none
   )
