module Update.Puppeteer.Hit exposing (forward, backward)

-- Elm -------------------------------------------------------------------------
import Array

-- Local Module ----------------------------------------------------------------
import Struct.Attack
import Struct.Battle
import Struct.TurnResult
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_damage_to_character : (
      Int ->
      Struct.Character.Type ->
      Struct.Character.Type
   )
apply_damage_to_character damage char =
   (Struct.Character.set_current_health
      ((Struct.Character.get_current_health char) - damage)
      char
   )

apply_to_characters : (
      Int ->
      Struct.Attack.Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_to_characters defender_ix attack characters =
   case (Array.get defender_ix characters) of
      (Just char) ->
         (Array.set
            defender_ix
            (apply_damage_to_character attack.damage char)
            characters
         )

      Nothing -> characters

apply_inverse_to_characters : (
      Int ->
      Struct.Attack.Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_inverse_to_characters defender_ix attack characters =
   case (Array.get defender_ix characters) of
      (Just char) ->
         (Array.set
            defender_ix
            (apply_damage_to_character (-1 * attack.damage) char)
            characters
         )

      Nothing -> characters

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Struct.TurnResult.Attack ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward attack model =
   (
      {model |
         battle =
            (Struct.Battle.set_characters
               (apply_to_characters
                  (Struct.TurnResult.get_attack_target_index attack)
                  (Struct.TurnResult.get_attack_data attack)
                  (Struct.Battle.get_characters model.battle)
               )
               model.battle
            )
      },
      []
   )


backward : (
      Struct.TurnResult.Attack ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward attack model =
   (
      {model |
         battle =
            (Struct.Battle.set_characters
               (apply_inverse_to_characters
                  (Struct.TurnResult.get_attack_target_index attack)
                  (Struct.TurnResult.get_attack_data attack)
                  (Struct.Battle.get_characters model.battle)
               )
               model.battle
            )
      },
      []
   )
