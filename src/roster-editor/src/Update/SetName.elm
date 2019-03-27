module Update.SetName exposing (apply_to)

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      String ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model name =
   (
      (
         case model.edited_char of
            (Just char) ->
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.set_base_character
                           (BattleCharacters.Struct.Character.set_name
                              name
                              (Struct.Character.get_base_character
                                 char
                              )
                           )
                           char
                        )
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
