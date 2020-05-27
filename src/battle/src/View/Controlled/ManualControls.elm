module View.Controlled.ManualControls exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Direction

-- Local Module ----------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
direction_button : (
      BattleMap.Struct.Direction.Type ->
      String ->
      (Html.Html Struct.Event.Type)
   )
direction_button dir label =
   (Html.div
      [
         (Html.Attributes.class ("manual-controls-" ++ label)),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.DirectionRequested dir)
         )
      ]
      []
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.div
      [
         (Html.Attributes.class "manual-controls")
      ]
      [
         (direction_button BattleMap.Struct.Direction.Left "left"),
         (direction_button BattleMap.Struct.Direction.Down "down"),
         (direction_button BattleMap.Struct.Direction.Up "up"),
         (direction_button BattleMap.Struct.Direction.Right "right")
      ]
   )
