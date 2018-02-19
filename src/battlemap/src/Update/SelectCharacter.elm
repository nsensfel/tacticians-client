module Update.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.Navigator
import Struct.Statistics
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
attack_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
attack_character model target_char_id target_char =
   {model |
      char_turn =
         (Struct.CharacterTurn.add_target model.char_turn target_char_id),
      ui =
         (Struct.UI.set_previous_action model.ui Nothing)
   }

ctrl_or_focus_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
ctrl_or_focus_character model target_char_id target_char =
   if (Struct.Character.is_enabled target_char)
   then
      {model |
         char_turn =
            (Struct.CharacterTurn.set_navigator
               (Struct.CharacterTurn.set_active_character
                  model.char_turn
                  target_char
               )
               (Struct.Navigator.new
                  (Struct.Character.get_location target_char)
                  (Struct.Statistics.get_movement_points
                     (Struct.Character.get_statistics target_char)
                  )
                  1 -- Attack Range
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

can_target_character : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Bool
   )
can_target_character model target =
   (
      (Struct.CharacterTurn.can_select_targets model.char_turn)
      &&
      (
         case
            (Struct.CharacterTurn.try_getting_navigator
               model.char_turn
            )
         of
            (Just nav) ->
               case
                  (Struct.Navigator.try_getting_path_to
                     nav
                     (Struct.Location.get_ref
                        (Struct.Character.get_location target)
                     )
                  )
               of
                  (Just _) -> True
                  _ -> False

            _ ->
               False
      )
   )

double_clicked_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
double_clicked_character model target_char_id =
   case (Dict.get target_char_id model.characters) of
      (Just target_char) ->
         case
            (Struct.CharacterTurn.try_getting_active_character
               model.char_turn
            )
         of
            (Just _) ->
               if (can_target_character model target_char)
               then
                  (
                     (attack_character
                        model
                        target_char_id
                        target_char
                     ),
                     Cmd.none
                  )
               else
                  (
                     (Struct.Model.invalidate
                        model
                        (Struct.Error.new
                           Struct.Error.IllegalAction
                           "Has not yet moved or target is out of range."
                        )
                     ),
                     Cmd.none
                  )

            _ ->
               (
                  (ctrl_or_focus_character model target_char_id target_char),
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
      (double_clicked_character model target_char_id)
   else
      (
         {model |
            ui =
               (Struct.UI.set_previous_action
                  (Struct.UI.set_displayed_tab
                     model.ui
                     Struct.UI.StatusTab
                  )
                  (Just (Struct.UI.SelectedCharacter target_char_id))
               )
         },
         Cmd.none
      )
