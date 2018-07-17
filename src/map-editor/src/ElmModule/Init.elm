module ElmModule.Init exposing (init)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Comm.LoadTilePatterns
import Comm.LoadTiles
import Comm.LoadMap

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
         (Cmd.batch
            [
               (case (Comm.LoadTiles.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               ),
               (case (Comm.LoadMap.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               ),
               (case (Comm.LoadTilePatterns.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               )
            ]
         )
      )
