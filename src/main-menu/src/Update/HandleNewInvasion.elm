module Update.HandleNewInvasion exposing (apply_to)
-- Elm -------------------------------------------------------------------------

-- Main Menu -------------------------------------------------------------------
import Struct.Event
import Struct.InvasionRequest
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
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ix =
   (
      {model |
         ui =
            (Struct.UI.set_action
               (Struct.UI.NewInvasion (Struct.InvasionRequest.new ix))
               model.ui
            )
      },
      Cmd.none
   )
