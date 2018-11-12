module Update.SetPortrait exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Dict

-- Roster Editor ---------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.Portrait

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.Portrait.Ref ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model ref =
   (
      (
         case (model.edited_char, (Dict.get ref model.portraits)) of
            ((Just char), (Just portrait)) ->
               {model |
                  edited_char =
                     (Just (Struct.Character.set_portrait portrait char))
               }

            _ -> model
      ),
      Cmd.none
   )
