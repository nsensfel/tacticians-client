module ElmModule.Init exposing (init)

-- Battlemap -------------------------------------------------------------------
import Comm.LoadBattlemap

import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
init : (Struct.Model.Type, (Cmd Struct.Event.Type))
init =
   let
      model = (Struct.Model.new)
   in
      (
         model,
         (case (Comm.LoadBattlemap.try model) of
            (Just cmd) -> cmd
            Nothing -> Cmd.none
         )
      )
