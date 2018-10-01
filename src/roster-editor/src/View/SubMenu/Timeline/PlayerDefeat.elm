module View.SubMenu.Timeline.PlayerDefeat exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
--import Html.Events

-- Map -------------------------------------------------------------------
import Struct.Event
import Struct.TurnResult

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.TurnResult.PlayerDefeat ->
      (Html.Html Struct.Event.Type)
   )
get_html pdefeat =
   (Html.div
      [
         (Html.Attributes.class "timeline-element"),
         (Html.Attributes.class "timeline-player-defeat")
      ]
      [
         (Html.text
            (
               "Player "
               ++ (toString pdefeat.player_index)
               ++ " has been eliminated."
            )
         )
      ]
   )
