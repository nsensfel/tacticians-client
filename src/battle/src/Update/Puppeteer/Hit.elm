module Update.Puppeteer.Hit exposing (forward, backward)

-- Elm -------------------------------------------------------------------------
import Array

-- Local Module ----------------------------------------------------------------
import Action.Scroll

import Struct.Attack
import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI

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
      Int ->
      Struct.Attack.Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_to_characters attacker_ix defender_ix attack characters =
   if ((attack.order == Struct.Attack.Counter) == attack.parried)
   then
      case (Array.get defender_ix characters) of
         (Just char) ->
            (Array.set
               defender_ix
               (apply_damage_to_character attack.damage char)
               characters
            )

         Nothing -> characters
   else
      case (Array.get attacker_ix characters) of
         (Just char) ->
            (Array.set
               attacker_ix
               (apply_damage_to_character attack.damage char)
               characters
            )

         Nothing -> characters

apply_inverse_to_characters : (
      Int ->
      Int ->
      Struct.Attack.Type ->
      (Array.Array Struct.Character.Type) ->
      (Array.Array Struct.Character.Type)
   )
apply_inverse_to_characters attacker_ix defender_ix attack characters =
   if ((attack.order == Struct.Attack.Counter) == attack.parried)
   then
      case (Array.get defender_ix characters) of
         (Just char) ->
            (Array.set
               defender_ix
               (apply_damage_to_character (-1 * attack.damage) char)
               characters
            )

         Nothing -> characters
   else
      case (Array.get attacker_ix characters) of
         (Just char) ->
            (Array.set
               attacker_ix
               (apply_damage_to_character (-1 * attack.damage) char)
               characters
            )

         Nothing -> characters

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Struct.Attack.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward hit model = (model, [])


backward : (
      Struct.Attack.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward hit model = (model, [])
