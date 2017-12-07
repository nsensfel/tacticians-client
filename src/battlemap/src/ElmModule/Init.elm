module ElmModule.Init exposing (init)

-- Battlemap -------------------------------------------------------------------
import Send.LoadBattlemap

import Shim.Model

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
      model = (Shim.Model.generate)
   in
      (
         model,
         (case (Send.LoadBattlemap.try model) of
            (Just cmd) -> cmd
            Nothing -> Cmd.none
         )
      )
