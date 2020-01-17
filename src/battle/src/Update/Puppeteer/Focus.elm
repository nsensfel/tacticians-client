module Update.Puppeteer.Focus exposing (forward, backward)

-- Elm -------------------------------------------------------------------------
import Task

-- Local Module ----------------------------------------------------------------
import Action.Scroll

import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model
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
   case (Struct.Battle.get_character actor_ix model.battle) of
      Nothing -> (model, [])
      (Just character) ->
         (
            model,
            [
               (Task.attempt
                  (Struct.Event.attempted)
                  (Action.Scroll.to
                     (Struct.Character.get_location character)
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
