module Update.CharacterTurn.ToggleTarget exposing (apply_to_ref)

-- Local Module ----------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
can_target_character : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Bool
   )
can_target_character model target =
   (
      (Struct.Character.is_alive target)
      &&
      (
         case
            (Struct.CharacterTurn.maybe_get_navigator
               model.char_turn
            )
         of
            (Just nav) ->
               case
                  (Struct.Navigator.maybe_get_path_to
                     (BattleMap.Struct.Location.get_ref
                        (Struct.Character.get_location target)
                     )
                     nav
                  )
               of
                  (Just _) -> True
                  _ -> False

            _ ->
               False
      )
   )

attack_character : (
      Struct.Model.Type ->
      Int ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
attack_character model target_char_id target_char =
   {model |
      char_turn =
         (Struct.CharacterTurn.set_target
            (Just target_char_id)
            model.char_turn
         ),
      ui =
         (Struct.UI.reset_displayed_nav
            (Struct.UI.reset_displayed_tab
               (Struct.UI.set_previous_action Nothing model.ui)
            )
         )
   }

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   (
      {model |
         char_turn = (Struct.CharacterTurn.new)
      },
      Cmd.none
   )
