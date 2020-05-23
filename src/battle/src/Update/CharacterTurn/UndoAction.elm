module Update.CharacterTurn.UndoAction exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Weapon

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.Navigator

import Util.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
handle_undo_switching_weapons : (
      Struct.CharacterTurn.Type ->
      Struct.CharacterTurn.Type
   )
handle_undo_switching_weapons char_turn =
   case (Struct.CharacterTurn.maybe_get_active_character char_turn) of
      Nothing -> char_turn

      (Just char) ->
         (Struct.CharacterTurn.clear_action
            (Struct.CharacterTurn.set_active_character
               (Struct.Character.set_base_character
                  (BattleCharacters.Struct.Character.switch_weapons
                     (Struct.Character.get_base_character char)
                  )
                  char
               )
               char_turn
            )
         )

handle_undo_attacking : Struct.CharacterTurn.Type -> Struct.CharacterTurn.Type
handle_undo_attacking char_turn =
   (Struct.CharacterTurn.clear_action
      (Struct.CharacterTurn.clear_target_indices
         (Struct.CharacterTurn.clear_locations
            char_turn
         )
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (
      {model |
         char_turn =
         (
            case (Struct.CharacterTurn.get_action model.char_turn) of
               Struct.CharacterTurn.Attacking ->
                  (handle_undo_attacking model.char_turn)

               Struct.CharacterTurn.UsingSkill ->
                  (handle_undo_attacking model.char_turn)

               Struct.CharacterTurn.SwitchingWeapons ->
                  (handle_undo_switching_weapons model.char_turn)

               _ -> model.char_turn
         )
      },
      Cmd.none
   )
