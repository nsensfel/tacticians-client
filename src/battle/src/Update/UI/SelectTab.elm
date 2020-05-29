module Update.UI.SelectTab exposing (apply_to)

-- Local Module ----------------------------------------------------------------
import Struct.Model
import Struct.Event
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.UI.Tab ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to tab model =
   if ((Struct.UI.maybe_get_displayed_tab model.ui) == (Just tab))
   then
      (
         {model | ui = (Struct.UI.clear_displayed_tab model.ui)},
         Cmd.none
      )
   else
      (
         {model | ui = (Struct.UI.set_displayed_tab tab model.ui)},
         Cmd.none
      )
