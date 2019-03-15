module Update.SetName exposing (apply_to)

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
                     (Just (Struct.Character.set_name name char))
               }

            _ -> model
      ),
      Cmd.none
   )
