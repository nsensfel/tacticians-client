module Update.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.Direction
import Struct.Error
import Struct.Event
import Struct.UI
import Struct.Model

import Update.RequestDirection

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
autopilot : Struct.Direction.Type -> Struct.Model.Type -> Struct.Model.Type
autopilot dir model =
   (Update.RequestDirection.apply_to model dir)

attack_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Character.Ref ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
attack_character model main_char_id target_char_id target_char =
   {model |
      targets = [target_char_id],
      ui = (Struct.UI.set_previous_action model.ui Nothing)
   }

select_character : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      Struct.Character.Type ->
      Struct.Model.Type
   )
select_character model target_char_id target_char =
   if ((Struct.Character.is_enabled target_char))
   then
      {model |
         state = Struct.Model.Default,
         controlled_character = (Just target_char_id),
         ui = (Struct.UI.set_previous_action model.ui Nothing),
         battlemap =
--            (Struct.Battlemap.set_navigator
--               (Struct.Character.get_location target_char)
--               (Struct.Character.get_movement_points target_char)
--               (Struct.Character.get_attack_range target_char)
--               (Dict.values model.characters)
                 model.battlemap
--            )
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
            case model.controlled_character of
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
