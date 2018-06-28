module View.SubMenu.Timeline.PlayerTurnStart exposing (get_html)

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
      Struct.TurnResult.PlayerTurnStart ->
      (Html.Html Struct.Event.Type)
   )
get_html pturns =
   (Html.div
      [
         (Html.Attributes.class "battlemap-timeline-element"),
         (Html.Attributes.class "battlemap-timeline-turn-start")
      ]
      [
         (Html.text
            (
               "Player "
               ++ (toString pturns.player_index)
               ++ "'s turn has started."
            )
         )
      ]
   )
