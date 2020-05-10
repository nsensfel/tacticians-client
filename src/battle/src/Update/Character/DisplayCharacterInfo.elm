module Update.Character.DisplayInfo exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Local Module ----------------------------------------------------------------
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
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to target_ref model =
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
