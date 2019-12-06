module Update.Puppeteer.Move exposing (forward, backward)

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Location

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
apply_direction_to_character : (
      Int ->
      Battle.Struct.Direction ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
apply_direction_to_character actor_ix direction model =
   let character = (Struct.Battle.get_character actor_ix model.battle) in
      (
         {model |
            battle =
               (Struct.Battle.set_character
                  actor_ix
                  (Struct.Character.dirty_set_location
                     (BattleMap.Struct.Location.neighbor
                        direction
                        (Struct.Character.get_location character)
                     )
                     character
                  )
                  model.battle
               )
         },
         []
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Int ->
      BattleMap.Struct.Direction ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward actor_ix direction model =
   (
      (apply_direction_to_character actor_ix direction model),
      []
   )


backward : (
      Int ->
      BattleMap.Struct.Direction ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward actor_ix direction model =
   (
      (apply_direction_to_character
         actor_ix
         (BattleMap.Struct.Direction.opposite_of direction)
         model
      ),
      []
   )
