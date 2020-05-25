module Update.CharacterTurn.AbortTurn exposing (apply_to, no_command_apply_to)

-- Elm -------------------------------------------------------------------------
import Set

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Location
import BattleMap.Struct.Map
import BattleMap.Struct.TileInstance

-- Local Module ----------------------------------------------------------------
import Constants.DisplayEffects

import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
remove_active_character_effects : (
      Struct.CharacterTurn.Type ->
      Struct.Battle.Type ->
      Struct.Battle.Type
   )
remove_active_character_effects char_turn battle =
   case (Struct.CharacterTurn.maybe_get_active_character char_turn) of
      Nothing -> battle
      (Just char) ->
         (Struct.Battle.update_character
            (Struct.Character.get_index char)
            (Struct.Character.remove_extra_display_effect
               Constants.DisplayEffects.active
            )
            battle
         )

remove_target_effects : (
      Struct.CharacterTurn.Type ->
      Struct.Battle.Type ->
      Struct.Battle.Type
   )
remove_target_effects char_turn battle =
   (Set.foldl
      (
         \target_index current_battle ->
            (Struct.Battle.update_character
               target_index
               (Struct.Character.remove_extra_display_effect
                  Constants.DisplayEffects.target
               )
               current_battle
            )
      )
      battle
      (Struct.CharacterTurn.get_target_indices char_turn)
   )


remove_location_effects : (
      Struct.CharacterTurn.Type ->
      Struct.Battle.Type ->
      Struct.Battle.Type
   )
remove_location_effects char_turn battle =
   (Struct.Battle.set_map
      (Set.foldl
         (
            \location_ref current_map ->
               (BattleMap.Struct.Map.update_tile_at
                  (BattleMap.Struct.Location.from_ref location_ref)
                  (BattleMap.Struct.TileInstance.remove_extra_display_effect
                     Constants.DisplayEffects.target
                  )
                  current_map
               )
         )
         (Struct.Battle.get_map battle)
         (Struct.CharacterTurn.get_locations char_turn)
      )
      battle
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
no_command_apply_to : Struct.Model.Type -> Struct.Model.Type
no_command_apply_to model =
   {model |
      char_turn = (Struct.CharacterTurn.new),
      battle =
         (remove_target_effects
            model.char_turn
            (remove_location_effects
               model.char_turn
               (remove_active_character_effects
                  model.char_turn
                  model.battle
               )
            )
         )
   }

apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (
      (no_command_apply_to model),
      Cmd.none
   )
