module Update.SetRequestedHelp exposing (apply_to)

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.HelpRequest
import Struct.MessageBoard
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
apply_to : (
      Struct.Model.Type ->
      Struct.HelpRequest.Type ->
      (Struct.Model.Type, (Cmd Struct.Event.Type))
   )
apply_to model help_request =
   (
      {model |
         message_board =
            (Struct.MessageBoard.display
               (Struct.MessageBoard.Help help_request)
               model.message_board
            )
      },
      Cmd.none
   )
