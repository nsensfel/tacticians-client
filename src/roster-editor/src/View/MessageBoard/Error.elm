module View.MessageBoard.Error exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Map -------------------------------------------------------------------
import Struct.Error
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.Error.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model error =
   (Html.div
      [
         (Html.Attributes.class "battle-message-board"),
         (Html.Attributes.class "battle-error")
      ]
      [
         (Html.text (Struct.Error.to_string error))
      ]
   )
