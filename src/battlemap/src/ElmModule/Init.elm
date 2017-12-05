module ElmModule.Init exposing (init)
-- Battlemap -------------------------------------------------------------------

import Struct.Model
import Struct.Event

import Shim.Model

import Send.LoadBattlemap

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
init : (Struct.Model.Type, (Cmd Event.Type))
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
