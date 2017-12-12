module Update.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Direction
import Struct.Error
import Struct.Event
import Struct.UI
import Struct.Model
import Struct.Navigator

import Update.RequestDirection

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
attack_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Character.Ref ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
attack_character model main_char_id target_char_id target_char =
   {model |
      char_turn =
         (Struct.CharacterTurn.add_target model.char_turn target_char_id),
      ui =
         (Struct.UI.set_previous_action model.ui Nothing)
   }

select_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
select_character model target_char_id target_char =
   if (Struct.Character.is_enabled target_char)
   then
      {model |
         char_turn =
            (Struct.CharacterTurn.set_navigator
               (Struct.CharacterTurn.set_controlled_character
                  model.char_turn
                  target_char
               )
               (Struct.Navigator.new
                  (Struct.Character.get_location target_char)
                  (Struct.Character.get_movement_points target_char)
                  (Struct.Character.get_attack_range target_char)
                  (Struct.Battlemap.get_movement_cost_function
                     model.battlemap
                     (Struct.Character.get_location target_char)
                     (Dict.values model.characters)
                  )
               )
            ),
         ui = (Struct.UI.set_previous_action model.ui Nothing)
      }
   else
      {model |
         ui =
            (Struct.UI.set_previous_action
               model.ui
               (Just (Struct.UI.SelectedCharacter target_char_id))
            )
      }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model target_char_id =
   if
   (
      (Struct.UI.get_previous_action model.ui)
      ==
      (Just (Struct.UI.SelectedCharacter target_char_id))
   )
   then
      case (Dict.get target_char_id model.characters) of
         (Just target_char) ->
            case
               (Struct.CharacterTurn.try_getting_controlled_character
                  model.char_turn
               )
            of
               (Just main_char_id) ->
                  (
                     (attack_character
                        model
                        main_char_id
                        target_char_id
                        target_char
                     ),
                     Cmd.none
                  )

               _ ->
                  (
                     (select_character model target_char_id target_char),
                     Cmd.none
                  )

         Nothing ->
            (
               (Struct.Model.invalidate
                  model
                  (Struct.Error.new
                     Struct.Error.Programming
                     "SelectCharacter: Unknown char selected."
                  )
               ),
               Cmd.none
            )
   else
      (
         {model |
            ui =
               (Struct.UI.set_previous_action
                  model.ui
                  (Just (Struct.UI.SelectedCharacter target_char_id))
               )
         },
         Cmd.none
      )
