module Struct.Event exposing (Type(..), attempted)

-- Elm -------------------------------------------------------------------------
import Http

-- Map -------------------------------------------------------------------
import Struct.Error
import Struct.ServerReply
import Struct.HelpRequest
import Struct.UI

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Type =
   None
   | Failed Struct.Error.Type
   | RequestedHelp Struct.HelpRequest.Type
   | SignInRequested
   | SignUpRequested
   | RecoveryRequested
   | SetUsername String
   | SetPassword1 String
   | SetPassword2 String
   | SetEmail1 String
   | SetEmail2 String
   | ServerReplied (Result Http.Error (List Struct.ServerReply.Type))
   | TabSelected Struct.UI.Tab

attempted : (Result.Result err val) -> Type
attempted act =
   case act of
      (Result.Ok _) -> None
      (Result.Err msg) ->
         (Failed (Struct.Error.new Struct.Error.Failure (toString msg)))
