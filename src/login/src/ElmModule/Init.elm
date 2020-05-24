module ElmModule.Init exposing (init)

-- Elm -------------------------------------------------------------------------

-- Shared ----------------------------------------------------------------------
import Shared.Struct.Flags

-- Local Module ----------------------------------------------------------
import Struct.Event
import Struct.Model

import Update.Disconnect
import Update.HandleConnected

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
init : Shared.Struct.Flags.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
init flags =
   let
      new_model = (Struct.Model.new flags)
   in
      case (Shared.Struct.Flags.maybe_get_parameter "action" flags) of
         (Just "disconnect") -> (Update.Disconnect.apply_to new_model)
         _ ->
            if (flags.user_id == "")
            then (new_model, Cmd.none)
            else (Update.HandleConnected.apply_to new_model)
