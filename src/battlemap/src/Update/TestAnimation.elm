module Update.TestAnimation exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Animation

-- Battlemap -------------------------------------------------------------------
import Struct.Model
import Struct.Event

type alias AnimationType = (Animation.State)
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
no_animation : AnimationType
no_animation =
   (Animation.style
      [
         (Animation.translate (Animation.percent 0.0) (Animation.percent 0.0))
      ]
   )

queue_go_up : AnimationType -> AnimationType
queue_go_up current_animation =
   (Animation.queue
      [
         (Animation.to
            [
               (Animation.translate
                  (Animation.percent 0.0)
                  (Animation.percent 100.0)
               )
            ]
         )
      ]
      current_animation
   )

queue_go_right : AnimationType -> AnimationType
queue_go_right current_animation =
   (Animation.queue
      [
         (Animation.to
            [
               (Animation.translate
                  (Animation.percent 100.0)
                  (Animation.percent 0.0)
               )
            ]
         )
      ]
      current_animation
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   (
      {model |
         animation = (Just (queue_go_right (queue_go_up (no_animation))))
      },
      Cmd.none
   )
