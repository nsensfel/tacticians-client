module Update.Puppeteer.SwapWeapons exposing (forward, backward)

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

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
                  (Struct.Character.set_base_character
                     (BattleCharacters.Struct.Character.dirty_switch_weapons
                        (Struct.Character.get_base_character character)
                     )
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
backward actor_ix model = (forward actor_ix model)