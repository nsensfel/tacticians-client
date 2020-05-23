module Update.CharacterTurn.RequestDirection exposing (apply_to)

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Map

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
make_it_so : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Navigator.Type ->
      BattleMap.Struct.Direction.Type ->
      Struct.Model.Type
   )
make_it_so model char navigator dir =
   case (Struct.Navigator.maybe_add_step dir navigator) of
      (Just new_navigator) ->
         {model |
            char_turn =
               (Struct.CharacterTurn.set_navigator
                  new_navigator
                  (Struct.CharacterTurn.set_active_character
                     (Struct.Character.set_base_character
                        (BattleCharacters.Struct.Character.set_extra_omnimods
                           (BattleMap.Struct.Map.get_omnimods_at
                              (Struct.Navigator.get_current_location
                                 new_navigator
                              )
                              model.map_data_set
                              (Struct.Battle.get_map model.battle)
                           )
                           (Struct.Character.get_base_character char)
                        )
                        char
                     )
                     model.char_turn
                  )
               ),
            ui =
               (Struct.UI.set_previous_action
                  (Just Struct.UI.UsedManualControls)
                  model.ui
               )
         }

      Nothing ->
         (Struct.Model.invalidate
            (Struct.Error.new
               Struct.Error.IllegalAction
               "Unreachable/occupied tile."
            )
            model
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      BattleMap.Struct.Direction.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to dir model =
   case
      (
         (Struct.CharacterTurn.maybe_get_navigator model.char_turn),
         (Struct.CharacterTurn.maybe_get_active_character model.char_turn)
      )
   of
      ((Just navigator), (Just char)) ->
         (
            (make_it_so model char navigator dir),
            Cmd.none
         )

      _ ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new
                  Struct.Error.IllegalAction
                  "This can only be done while moving a character."
               )
               model
            ),
            Cmd.none
         )
