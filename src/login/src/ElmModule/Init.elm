module ElmModule.Init exposing (init)

-- Elm -------------------------------------------------------------------------

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.Flags
import Struct.Model

import Update.Disconnect
import Update.HandleConnected

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
init : Struct.Flags.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
init flags =
   let
      new_model = (Struct.Model.new flags)
   in
      case (Struct.Flags.maybe_get_param "action" flags) of
         (Just "disconnect") -> (Update.Disconnect.apply_to new_model)
         _ ->
            if (flags.user_id == "")
            then (new_model, Cmd.none)
            else (Update.HandleConnected.apply_to new_model)
