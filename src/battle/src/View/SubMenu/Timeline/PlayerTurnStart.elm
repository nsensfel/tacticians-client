module View.SubMenu.Timeline.PlayerTurnStart exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Local Module ----------------------------------------------------------------
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
         (Html.Attributes.class "timeline-element"),
         (Html.Attributes.class "timeline-turn-start")
      ]
      [
         (Html.text
            (
               "Player "
               ++ (String.fromInt pturns.player_index)
               ++ "'s turn has started."
            )
         )
      ]
   )
