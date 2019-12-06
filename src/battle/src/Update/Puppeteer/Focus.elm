module Update.Puppeteer.Focus exposing (forward, backward)

-- Local Module ----------------------------------------------------------------
import Struct.Model
import Struct.Event
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward actor_ix model =
   (
      model,
      [
         (Task.attempt
            (Struct.Event.attempted)
            (Action.Scroll.to
               (Struct.Character.get_location
                  (Struct.Battle.get_character actor_ix model.battle)
               )
               model.ui
            )
         )
      ]
   )


backward : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward actor_ix model = (model, [])
