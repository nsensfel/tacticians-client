module Update.UI.ChangeScale exposing (apply_to)

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
      Float ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to mod model =
   if (mod == 0.0)
   then ({model | ui = (Struct.UI.reset_zoom_level model.ui)}, Cmd.none)
   else ({model | ui = (Struct.UI.mod_zoom_level mod model.ui)}, Cmd.none)
