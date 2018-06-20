module Update.HandleAnimationEnded exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Model

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
   case model.animator of
      Nothing -> ((Struct.Model.initialize_animator model), Cmd.none)
      (Just _) -> ((Struct.Model.apply_animator_step model), Cmd.none)
