module Update.SelectTile exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Location
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
      Struct.Location.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model loc_ref =
   (
      {model |
         ui =
            (Struct.UI.reset_displayed_nav
               (Struct.UI.set_displayed_tab
                  Struct.UI.StatusTab
                  (Struct.UI.set_previous_action
                     (Just (Struct.UI.SelectedLocation loc_ref))
                     model.ui
                  )
               )
            )
      },
      Cmd.none
   )
