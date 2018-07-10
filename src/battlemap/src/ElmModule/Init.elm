module ElmModule.Init exposing (init)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Comm.LoadBattlemap

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
   let model = (Struct.Model.new flags) in
      (
         model,
         (case (Comm.LoadBattlemap.try model) of
            (Just cmd) -> cmd
            Nothing -> Cmd.none
         )
      )
