module View.MessageBoard.Help exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.HelpRequest
import Struct.Model

import View.MessageBoard.Help.Guide

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "message-board"),
         (Html.Attributes.class "message-board-help")
      ]
      (
         case model.help_request of
            Struct.HelpRequest.None ->
               (View.MessageBoard.Help.Guide.get_html_contents model)
      )
   )
