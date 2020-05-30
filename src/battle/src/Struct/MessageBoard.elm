module Struct.MessageBoard exposing
   (
      Type,
      Message(..),
      display,
      maybe_get_current_message,
      clear_current_message,
      clear_main_message,
      new,
      clear
   )

-- Elm -------------------------------------------------------------------------

-- Local Module ----------------------------------------------------------------
import Struct.Attack
import Struct.Error
import Struct.HelpRequest

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------
type Message =
   Help Struct.HelpRequest.Type
   | Error Struct.Error.Type
   | AttackReport Struct.Attack.Type

type alias Type =
   {
      secondary_messages : (List Message),
      main_message : (Maybe Message)
   }

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
display : Message -> Type -> Type
display message board =
   case message of
      (AttackReport _) -> {board | main_message = (Just message)}
      _ ->
         {board |
            secondary_messages = (message :: board.secondary_messages)
         }

maybe_get_current_message : Type -> (Maybe Message)
maybe_get_current_message board =
   case board.secondary_messages of
      [] -> board.main_message
      (secondary_message :: _) -> (Just secondary_message)

clear_current_message : Type -> Type
clear_current_message board =
   case board.secondary_messages of
      [] -> {board | main_message = Nothing}
      (_ :: remaining_secondary_messages) ->
         {board |
            secondary_messages = remaining_secondary_messages
         }

clear_main_message : Type -> Type
clear_main_message board = {board | main_message = Nothing}

new : Type
new =
   {
      secondary_messages = [],
      main_message = Nothing
   }

clear : Type -> Type
clear board = (new)
