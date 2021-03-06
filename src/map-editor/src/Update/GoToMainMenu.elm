module Update.GoToMainMenu exposing (apply_to)

-- Shared ----------------------------------------------------------------------
import Action.Ports

-- Battle ----------------------------------------------------------------------
import Constants.IO

import Struct.Model
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (
      model,
      (Action.Ports.go_to (Constants.IO.base_url ++"/main-menu/"))
   )
