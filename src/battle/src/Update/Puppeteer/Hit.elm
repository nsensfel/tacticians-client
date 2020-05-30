module Update.Puppeteer.Hit exposing (forward, backward)

-- Elm -------------------------------------------------------------------------

-- Local Module ----------------------------------------------------------------
import Struct.Attack
import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_damage_to_character : Int -> Int -> Struct.Model.Type -> Struct.Model.Type
apply_damage_to_character damage char_ix model =
   {model |
      battle =
         (Struct.Battle.update_character
            char_ix
            (\char ->
               (Struct.Character.set_current_health
                  ((Struct.Character.get_current_health char) - damage)
                  char
               )
            )
            model.battle
         )
   }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Struct.Attack.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward attack model =
   (
      (apply_damage_to_character
         (Struct.Attack.get_damage attack)
         (Struct.Attack.get_target_index attack)
         model
      ),
      []
   )


backward : (
      Struct.Attack.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward attack model =
   (
      (apply_damage_to_character
         ((Struct.Attack.get_damage attack) * -1)
         (Struct.Attack.get_target_index attack)
         model
      ),
      []
   )
