module ElmModule.Init exposing (init)

-- Elm -------------------------------------------------------------------------

-- Main Menu -------------------------------------------------------------------
import Comm.LoadPlayer

import Struct.Event
import Struct.Flags
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
init : Struct.Flags.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
init flags =
   let
      model = (Struct.Model.new flags)
   in
      case (Comm.LoadPlayer.try model) of
         Nothing -> (model, Cmd.none)
         (Just command) -> (model, command)
