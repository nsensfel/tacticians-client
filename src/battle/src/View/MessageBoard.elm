module View.MessageBoard exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.MessageBoard

import View.MessageBoard.Attack
import View.MessageBoard.Error
import View.MessageBoard.Help

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
display : (
      Struct.Model.Type ->
      Struct.MessageBoard.Message ->
      (Html.Html Struct.Event.Type)
   )
display model message =
   case message of
      (Error error_msg) -> (View.MessageBoard.Error.get_html model error_msg)
      (AttackReport attack) -> (View.MessageBoard.Attack.get_html model attack)
      (Help help_request) ->
         (View.MessageBoard.Help.get_html model help_request)

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (Struct.MessageBoard.maybe_get_current_message model.message_board) of
      Nothing -> (Util.Html.nothing)
      (Just message) -> (display model message)
