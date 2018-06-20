module Update.HandleAnimationEnded exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Delay

import Time

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
      Nothing -> (model, Cmd.none)
      (Just _) ->
         (
            (Struct.Model.apply_animator_step model),
            (Delay.after 0.3 Time.second Struct.Event.AnimationEnded)
         )
