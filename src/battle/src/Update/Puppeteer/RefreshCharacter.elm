module Update.Puppeteer.RefreshCharacter exposing (forward, backward)

-- Local Module ----------------------------------------------------------------
import Struct.Battle
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
perform actor_ix model =
   (
      {model |
         battle =
            (Struct.Battle.refresh_character
               model.map_data_set
               actor_ix
               model.battle
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
forward is_forward actor_ix model =
   if (is_forward)
   then (perform actor_ix model)
   else (model, [])


backward : (
      Bool ->
      Int ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward is_forward actor_ix model =
   if (is_forward)
   then (model, [])
   else (perform actor_ix model)
