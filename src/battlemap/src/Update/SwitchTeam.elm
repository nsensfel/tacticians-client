module Update.SwitchTeam exposing (apply_to)
-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Model
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   if (model.controlled_team == 0)
   then
      (
         (Model.reset
            {model |
               controlled_team = 1,
               player_id = "1"
            }
            model.characters
         ),
         Cmd.none
      )
   else
      (
         (Model.reset
            {model |
               controlled_team = 0,
               player_id = "0"
            }
            model.characters
         ),
         Cmd.none
      )
