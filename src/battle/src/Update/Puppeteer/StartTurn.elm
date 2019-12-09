module Update.Puppeteer.StartTurn exposing (forward, backward)

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
set_player_characters_are_enabled : (
      Bool ->
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
set_player_characters_are_enabled val player_ix model =
   (
      {model |
         battle =
            (Struct.Battle.set_characters
               (Array.map
                  (\character ->
                     if ((Struct.Character.get_player_index c) == player_ix)
                     then (Struct.Character.set_enabled val character)
                     else character
                  )
               )
               (Struct.Battle.get_characters model.battle)
            )
      },
      []
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward player_ix model =
   (set_player_characters_are_enabled True player_ix model)

backward : (
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward player_ix model =
   (set_player_characters_are_enabled False player_ix model)
