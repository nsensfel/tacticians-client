module Update.SwitchWeapons exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Roster Editor ---------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.UI
import Struct.Weapon

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model =
   (
      (
         case model.edited_char of
            (Just char) ->
               {model |
                  edited_char =
                     (Just
                        (Struct.Character.switch_weapons
                           char
                        )
                     )
               }

            _ -> model
      ),
      Cmd.none
   )
