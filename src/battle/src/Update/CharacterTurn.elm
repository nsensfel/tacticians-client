module Update.CharacterTurn exposing (apply_to)

-- Elm -------------------------------------------------------------------------

-- Local Module ----------------------------------------------------------------
import Constants.DisplayEffects

import Struct.Battle
import Struct.CharacterTurn
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Navigator

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Character.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to target_char model =
   let
      nav =
         (case (Struct.UI.maybe_get_displayed_nav model.ui) of
            (Just dnav) -> dnav
            Nothing ->
               (Util.Navigator.get_character_navigator
                  model.battle
                  target_char
               )
         )
   in
      (
         {model |
            char_turn =
               (Struct.CharacterTurn.set_navigator
                  nav
                  (Struct.CharacterTurn.set_active_character
                     target_char
                     (Struct.CharacterTurn.new)
                  )
               ),
            battle =
               (Struct.Battle.update_character
                  (Struct.Character.get_index target_char)
                  (Struct.Character.add_extra_display_effect
                     Constants.DisplayEffects.active_character
                  )
                  model.battle
               ),
            ui =
               (Struct.UI.reset_displayed_nav
                  (Struct.UI.reset_displayed_tab
                     (Struct.UI.set_previous_action Nothing model.ui)
                  )
               )
         },
         Cmd.none
      )
