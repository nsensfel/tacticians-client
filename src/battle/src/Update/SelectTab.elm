module Update.SelectTab exposing (apply_to)

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
      Struct.Model.Type ->
      Struct.UI.Tab ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model tab =
   if ((Struct.UI.try_getting_displayed_tab model.ui) == (Just tab))
   then
      (
         {model | ui = (Struct.UI.reset_displayed_tab model.ui)},
         Cmd.none
      )
   else
      (
         {model | ui = (Struct.UI.set_displayed_tab tab model.ui)},
         Cmd.none
      )
