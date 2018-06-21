module View.MessageBoard.Error exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
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
         (Html.Attributes.class "battlemap-help"),
         (Html.Attributes.class "battlemap-error")
      ]
      [
         (Html.text (Struct.Error.to_string error))
      ]
   )
