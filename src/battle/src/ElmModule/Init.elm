module ElmModule.Init exposing (init)

-- Shared ----------------------------------------------------------------------
import Shared.Struct.Flags

-- Local Module ----------------------------------------------------------------
import Comm.LoadBattle

import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
init : Shared.Struct.Flags.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
init flags =
   let model = (Struct.Model.new flags) in
      (
         model,
         (case (Comm.LoadBattle.try model) of
            (Just cmd) -> cmd
            Nothing -> Cmd.none
         )
      )
