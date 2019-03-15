module Update.ClearToolboxSelection exposing (apply_to)

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Toolbox
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   (
      {model | toolbox = (Struct.Toolbox.clear_selection model.toolbox)},
      Cmd.none
   )
