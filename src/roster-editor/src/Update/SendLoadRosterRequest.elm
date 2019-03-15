module Update.SendLoadRosterRequest exposing (apply_to)

-- Local Module ----------------------------------------------------------------
import Comm.LoadRoster

import Struct.Event
import Struct.Model

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
      (case (Comm.LoadRoster.try model) of
         (Just cmd) -> cmd
         Nothing -> Cmd.none
      )
   )

