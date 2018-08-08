module ElmModule.Update exposing (update)

-- Elm -------------------------------------------------------------------------

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.Model

import Update.HandleServerReply
import Update.SendSignIn
import Update.SendSignUp
import Update.SelectTab

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

      Struct.Event.SendSignInRequested ->
         (Update.SendSignIn.apply_to new_model)

      Struct.Event.SendSignUpRequested ->
         (Update.SendSignUp.apply_to model)

      (Struct.Event.TabSelected tab) ->
         (Update.SelectTab.apply_to new_model tab)

      (Struct.Event.RequestedHelp _) ->
         -- TODO
         (model, Cmd.none)
