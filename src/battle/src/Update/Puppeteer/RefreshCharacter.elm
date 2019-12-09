module Update.Puppeteer.RefreshCharacter exposing (forward, backward)

-- FIXME: This might not be the way to go about it. This works when going
-- forward, as all the "dirty" changes have applied before the character is
-- refreshed, but this step will appear *before* the changes when going
-- backward, which means those changes are not taken into account during the
-- "refresh".

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
   let character = (Struct.Battle.get_character actor_ix model.battle) in
      (
         {model |
            battle =
               (Struct.Battle.set_character
                  actor_ix
                  (Struct.Character.set_location
                     (Struct.Character.get_location character)
                     character
                  )
                  model.battle
               )
         },
         []
      )


backward : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward actor_ix model = (model, [])
