module View.SubMenu.Timeline.PlayerDefeat exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
--import Html.Events

-- Battlemap -------------------------------------------------------------------
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
         (Html.Attributes.class "battlemap-timeline-element"),
         (Html.Attributes.class "battlemap-timeline-player-defeat")
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
