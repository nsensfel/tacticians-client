module ElmModule.Init exposing (init)

-- Shared ----------------------------------------------------------------------
import Shared.Struct.Flags

-- Local Module ----------------------------------------------------------------
import Comm.LoadRoster
import Comm.LoadArmors
import Comm.LoadWeapons
import Comm.LoadPortraits
import Comm.LoadGlyphs
import Comm.LoadSkills
import Comm.LoadGlyphBoards

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
         (Cmd.batch
            [
               (case (Comm.LoadArmors.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               ),
               (case (Comm.LoadWeapons.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               ),
               (case (Comm.LoadGlyphs.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               ),
               (case (Comm.LoadGlyphBoards.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               ),
               (case (Comm.LoadPortraits.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               ),
               (case (Comm.LoadSkills.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               ),
               (case (Comm.LoadRoster.try model) of
                  (Just cmd) -> cmd
                  Nothing -> Cmd.none
               )
            ]
         )
      )
