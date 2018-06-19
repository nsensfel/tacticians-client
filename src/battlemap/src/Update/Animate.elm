module Update.Animate exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Animation

-- Battlemap -------------------------------------------------------------------
import Struct.Model
import Struct.Event

type alias AnimationType = (Animation.State)
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Animation.Msg ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model anim_msg =
   (
      (
         case model.animation of
            (Just curr_anim) ->
               {model |
                  animation = (Just (Animation.update anim_msg curr_anim))
               }

            Nothing ->
               model
      ),
      Cmd.none
   )
