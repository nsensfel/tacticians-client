module ElmModule.Update exposing (update)

-- Elm -------------------------------------------------------------------------

-- Main Menu -------------------------------------------------------------------
import Struct.Event
import Struct.Model

import Update.HandleNewInvasion
import Update.HandleServerReply

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
update : (
      Struct.Event.Type ->
      Struct.Model.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
update event model =
   let
      new_model = (Struct.Model.clear_error model)
   in
   case event of
      Struct.Event.None -> (model, Cmd.none)

      (Struct.Event.Failed err) ->
         (
            (Struct.Model.invalidate err new_model),
            Cmd.none
         )

      (Struct.Event.ServerReplied result) ->
         (Update.HandleServerReply.apply_to model result)

      (Struct.Event.NewInvasion ix) ->
         (Update.HandleNewInvasion.apply_to new_model ix)

      (Struct.Event.InvasionSetSize size) ->
         (Update.HandleNewInvasion.set_size new_model size)

      (Struct.Event.InvasionSetCategory cat) ->
         (Update.HandleNewInvasion.set_category new_model cat)

      (Struct.Event.InvasionSetMap map_summary) ->
         (Update.HandleNewInvasion.set_map new_model map_summary)

      (Struct.Event.TabSelected tab) -> (model, Cmd.none)
