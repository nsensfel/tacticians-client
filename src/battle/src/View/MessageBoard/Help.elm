module View.MessageBoard.Help exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battle ----------------------------------------------------------------------
import Battle.View.Help.DamageType
import Battle.View.Help.Attribute

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.HelpRequest
import Struct.Model

import View.MessageBoard.Help.Guide
import View.MessageBoard.Help.Rank

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.HelpRequest.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model help_request =
   (Html.div
      [
         (Html.Attributes.class "message-board"),
         (Html.Attributes.class "message-board-help")
      ]
      (
         case help_request of
            Struct.HelpRequest.None ->
               (View.MessageBoard.Help.Guide.get_html_contents model)

            (Struct.HelpRequest.Rank rank) ->
               (View.MessageBoard.Help.Rank.get_html_contents rank)

            (Struct.HelpRequest.Attribute att_cat) ->
               (Battle.View.Help.Attribute.get_html_contents att_cat)

            (Struct.HelpRequest.DamageType dmg_cat) ->
               (Battle.View.Help.DamageType.get_html_contents dmg_cat)

--            _ -> [(Html.text "Help is not available for this, yet.")]
      )
   )
