module Update.Puppeteer.RefreshCharacter exposing (forward, backward)

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
                     -- TODO:
                     -- Handle both Struct.Character.dirty_set_location and
                     -- BattleCharacters.Struct.Character.dirty_switch_weapons.
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
