module Model.HandleServerReply exposing (apply_to)

-- Battlemap -------------------------------------------------------------------
import Model
import Error
import Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Model.Type -> String -> (Model.Type, (Cmd Event.Type))
apply_to model serialized_commands =
   (
      (Model.invalidate
         model
         (Error.new Error.Unimplemented "Received reply from server.")
      ),
      Cmd.none
   )
