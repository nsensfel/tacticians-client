module View.SubMenu.Timeline.PlayerVictory exposing (get_html)

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
      Struct.TurnResult.PlayerVictory ->
      (Html.Html Struct.Event.Type)
   )
get_html pvict =
   (Html.div
      [
         (Html.Attributes.class "battlemap-timeline-element"),
         (Html.Attributes.class "battlemap-timeline-player-victory")
      ]
      [
         (Html.text
            (
               "Player "
               ++ (toString pvict.player_index)
               ++ " has won the battle."
            )
         )
      ]
   )
