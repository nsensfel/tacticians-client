module Update.SelectCharacter exposing (apply_to)

-- Elm -------------------------------------------------------------------------
import Array

-- Local Module ----------------------------------------------------------------
import Struct.Error
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
      Int ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model target_char_ix =
   -- TODO: store currently edited char, if it exists.
   -- Basically, there will be a marker on characters to tell if they've been
   -- edited. There will also be a "Save" button, like in the map editor, that
   -- will send all modified characters to the server (and mark them as
   -- up-to-date).
   (
      (
         case (Array.get target_char_ix model.characters) of
            Nothing ->
               (Struct.Model.invalidate
                  (Struct.Error.new
                     Struct.Error.Programming
                     (
                        "Unknown character index selected \""
                        ++ (String.fromInt target_char_ix)
                        ++ "\"."
                     )
                  )
                  model
               )

            (Just char) -> {model | edited_char = (Just char)}
      ),
      Cmd.none
   )
