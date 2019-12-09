module Update.Puppeteer.RefreshCharactersOfPlayer exposing (forward, backward)

-- Elm -------------------------------------------------------------------------
import Array

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
perform : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
perform player_ix model =
   (
      {model |
         battle =
            (Array.foldl
               (\actor battle ->
                  if ((Struct.Character.get_player_index actor) == player_ix)
                  then
                     (Struct.Battle.refresh_character
                        (Struct.Character.get_index actor)
                        battle
                     )
                  else battle
               )
               model.battle
               (Struct.Battle.get_characters model.battle)
            )
      },
      []
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Bool ->
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward is_forward player_ix model =
   if (is_forward)
   then (perform player_ix model)
   else (model, [])

backward : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward is_forward player_ix model =
   if (is_forward)
   then (model, [])
   else (perform player_ix model)
