module ElmModule.Update exposing (update)

-- Elm -------------------------------------------------------------------------

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.Model

import Update.ChangeScale
import Update.HandleServerReply
import Update.SelectTab
import Update.SelectTile
import Update.SetRequestedHelp

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

      (Struct.Event.TileSelected loc) ->
         (Update.SelectTile.apply_to new_model loc)

      (Struct.Event.ScaleChangeRequested mod) ->
         (Update.ChangeScale.apply_to new_model mod)

      (Struct.Event.TabSelected tab) ->
         (Update.SelectTab.apply_to new_model tab)

      (Struct.Event.ServerReplied result) ->
         (Update.HandleServerReply.apply_to model result)

      (Struct.Event.RequestedHelp help_request) ->
         (Update.SetRequestedHelp.apply_to new_model help_request)
