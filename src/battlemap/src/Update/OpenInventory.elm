module Update.OpenInventory exposing (apply_to)
-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Model
import Struct.Event
import Struct.Error

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
   (
      (Struct.Model.invalidate
         model
         (Struct.Error.new
            Struct.Error.Unimplemented
            "Display Character Inventory"
         )
      ),
      Cmd.none
   )
