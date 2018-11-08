module Update.SendRoster exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

-- Roster Editor ---------------------------------------------------------------
import Comm.UpdateRoster

import Struct.Character
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
      {model |
         characters = model.characters
--            (Array.map
 --              (Struct.Character.set_was_edited False)
  --             model.characters
   --         )
      },
      (case (Comm.UpdateRoster.try model) of
         (Just cmd) -> cmd
         Nothing -> Cmd.none
      )
   )

