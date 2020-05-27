module Update.CharacterTurn.ResetPath exposing (apply_to)

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction
import BattleMap.Struct.Location
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

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : Struct.Model.Type -> (Struct.Model.Type, (Cmd Struct.Event.Type))
apply_to model =
   case
      (
         (Struct.CharacterTurn.maybe_get_active_character model.char_turn),
         (Struct.CharacterTurn.maybe_get_navigator model.char_turn)
      )
   of
      ((Just char), (Just nav)) ->
         let
            new_location = (Struct.Navigator.get_starting_location nav)
         in
            (
               {model |
                  char_turn =
                     (Struct.CharacterTurn.set_navigator
                        (Struct.Navigator.clear_path
                           (Struct.Navigator.unlock_path nav)
                        )
                        (Struct.CharacterTurn.set_active_character
                           (Struct.Character.set_location
                              new_location
                              (BattleMap.Struct.Map.get_omnimods_at
                                 new_location
                                 model.map_data_set
                                 (Struct.Battle.get_map model.battle)
                              )
                              char
                           )
                           (Struct.CharacterTurn.clear_path model.char_turn)
                        )
                     )
               },
               Cmd.none
            )

      _ ->
         (
            (Struct.Model.invalidate
               (Struct.Error.new
                  Struct.Error.IllegalAction
                  "This can only be done while controlling a character."
               )
               model
            ),
            Cmd.none
         )
