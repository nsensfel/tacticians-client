module Struct.Model exposing
   (
      Type,
      new,
      add_character,
      update_character,
      update_character_fun,
      add_weapon,
      add_armor,
      add_tile,
      invalidate,
      initialize_animator,
      apply_animator_step,
      move_animator_to_next_step,
      reset,
      full_debug_reset,
      clear_error
   )

-- Elm -------------------------------------------------------------------------
import Array

import Dict

-- Map -------------------------------------------------------------------
import Struct.Armor
import Struct.Map
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Flags
import Struct.HelpRequest
import Struct.Tile
import Struct.TurnResult
import Struct.TurnResultAnimator
import Struct.UI
import Struct.Weapon

import Util.Array

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type alias Type =
   {
      help_request: Struct.HelpRequest.Type,
      animator: (Maybe Struct.TurnResultAnimator.Type),
      map: Struct.Map.Type,
      characters: (Array.Array Struct.Character.Type),
      weapons: (Dict.Dict Struct.Weapon.Ref Struct.Weapon.Type),
      armors: (Dict.Dict Struct.Armor.Ref Struct.Armor.Type),
      tiles: (Dict.Dict Struct.Tile.Ref Struct.Tile.Type),
      error: (Maybe Struct.Error.Type),
      player_id: String,
      battle_id: String,
      session_token: String,
      player_ix: Int,
      ui: Struct.UI.Type,
      char_turn: Struct.CharacterTurn.Type,
      timeline: (Array.Array Struct.TurnResult.Type)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
new : Struct.Flags.Type -> Type
new flags =
   let
      maybe_battle_id = (Struct.Flags.maybe_get_param "id" flags)
      model =
         {
            help_request = Struct.HelpRequest.None,
            animator = Nothing,
            map = (Struct.Map.empty),
            characters = (Array.empty),
            weapons = (Dict.empty),
            armors = (Dict.empty),
            tiles = (Dict.empty),
            error = Nothing,
            battle_id = "",
            player_id =
               (
                  if (flags.user_id == "")
                  then "0"
                  else flags.user_id
               ),
            session_token = flags.token,
            player_ix = 0,
            ui = (Struct.UI.default),
            char_turn = (Struct.CharacterTurn.new),
            timeline = (Array.empty)
         }
   in
      case maybe_battle_id of
         Nothing ->
            (invalidate
               (Struct.Error.new
                  Struct.Error.Failure
                  "Could not find battle id."
               )
               model
            )

         (Just id) -> {model | battle_id = id}

add_character : Struct.Character.Type -> Type -> Type
add_character char model =
   {model |
      characters =
         (Array.push
            char
            model.characters
         )
   }

add_weapon : Struct.Weapon.Type -> Type -> Type
add_weapon wp model =
   {model |
      weapons =
         (Dict.insert
            (Struct.Weapon.get_id wp)
            wp
            model.weapons
         )
   }

add_armor : Struct.Armor.Type -> Type -> Type
add_armor ar model =
   {model |
      armors =
         (Dict.insert
            (Struct.Armor.get_id ar)
            ar
            model.armors
         )
   }

add_tile : Struct.Tile.Type -> Type -> Type
add_tile tl model =
   {model |
      tiles =
         (Dict.insert
            (Struct.Tile.get_id tl)
            tl
            model.tiles
         )
   }

reset : Type -> Type
reset model =
   {model |
      help_request = Struct.HelpRequest.None,
      error = Nothing,
      ui =
         (Struct.UI.reset_displayed_nav
            (Struct.UI.set_previous_action Nothing model.ui)
         ),
      char_turn = (Struct.CharacterTurn.new)
   }

full_debug_reset : Type -> Type
full_debug_reset model =
   {model |
      help_request = Struct.HelpRequest.None,
      animator = Nothing,
      map = (Struct.Map.empty),
      characters = (Array.empty),
      weapons = (Dict.empty),
      armors = (Dict.empty),
      tiles = (Dict.empty),
      error = Nothing,
      ui = (Struct.UI.default),
      char_turn = (Struct.CharacterTurn.new),
      timeline = (Array.empty)
   }

initialize_animator : Type -> Type
initialize_animator model =
   let
      timeline_list = (Array.toList model.timeline)
   in
      {model |
         animator =
            (Struct.TurnResultAnimator.maybe_new
               (List.reverse timeline_list)
               True
            ),
         ui = (Struct.UI.default),
         characters =
            (List.foldr
               (Struct.TurnResult.apply_inverse_to_characters)
               model.characters
               timeline_list
            )
      }

move_animator_to_next_step : Type -> Type
move_animator_to_next_step model =
   case model.animator of
      Nothing -> model
      (Just animator) ->
         {model |
            animator =
               (Struct.TurnResultAnimator.maybe_trigger_next_step animator)
         }

apply_animator_step : Type -> Type
apply_animator_step model =
   case model.animator of
      Nothing -> model
      (Just animator) ->
         {model |
            characters =
               case
                  (Struct.TurnResultAnimator.get_current_animation animator)
               of
                  (Struct.TurnResultAnimator.TurnResult turn_result) ->
                     (Struct.TurnResult.apply_step_to_characters
                        turn_result
                        model.characters
                     )

                  _ -> model.characters
         }

update_character : Int -> Struct.Character.Type -> Type -> Type
update_character ix new_val model =
   {model |
      characters = (Array.set ix new_val model.characters)
   }

update_character_fun : (
      Int ->
      ((Maybe Struct.Character.Type) -> (Maybe Struct.Character.Type)) ->
      Type ->
      Type
   )
update_character_fun ix fun model =
   {model |
      characters = (Util.Array.update ix (fun) model.characters)
   }

invalidate : Struct.Error.Type -> Type -> Type
invalidate err model =
   {model |
      error = (Just err)
   }

clear_error : Type -> Type
clear_error model = {model | error = Nothing}
