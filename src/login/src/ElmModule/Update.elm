module ElmModule.Update exposing (update)

-- Elm -------------------------------------------------------------------------

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.Model

import Update.HandleConnected
import Update.HandleServerReply
import Update.SendSignIn
import Update.SendSignUp
import Update.SendRecovery
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

      Struct.Event.SignInRequested ->
         (Update.SendSignIn.apply_to new_model)

      Struct.Event.SignUpRequested ->
         (Update.SendSignUp.apply_to model)

      Struct.Event.RecoveryRequested ->
         (Update.SendRecovery.apply_to model)

      (Struct.Event.TabSelected tab) ->
         (Update.SelectTab.apply_to new_model tab)

      (Struct.Event.RequestedHelp _) ->
         -- TODO
         (model, Cmd.none)

      (Struct.Event.SetUsername str) ->
         (
            {model | username = str},
            Cmd.none
         )

      (Struct.Event.SetPassword1 str) ->
         (
            {model | password1 = str},
            Cmd.none
         )

      (Struct.Event.SetPassword2 str) ->
         (
            {model | password2 = str},
            Cmd.none
         )

      (Struct.Event.SetEmail1 str) ->
         (
            {model | email1 = str},
            Cmd.none
         )

      (Struct.Event.SetEmail2 str) ->
         (
            {model | email2 = str},
            Cmd.none
         )

      Struct.Event.Connected -> (Update.HandleConnected.apply_to model)
