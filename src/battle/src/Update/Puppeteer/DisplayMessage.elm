module Update.Puppeteer.DisplayMessage exposing (forward, backward)

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.MessageBoard
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
forward : (
      Struct.MessageBoard.Message ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
forward message model =
   (
      {model |
         message_board =
            (Struct.MessageBoard.display message model.message_board)
      },
      []
   )


backward : (
      Struct.MessageBoard.Message ->
      Struct.Model.Type ->
      (Struct.Model.Type, (List (Cmd Struct.Event.Type)))
   )
backward message model =
   (
      {model |
         message_board =
            (Struct.MessageBoard.clear_main_message model.message_board)
      },
      []
   )
