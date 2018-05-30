module View.Controlled.ManualControls exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Direction
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
direction_button : (
      Struct.Direction.Type ->
      String ->
      (Html.Html Struct.Event.Type)
   )
direction_button dir label =
   (Html.div
      [
         (Html.Attributes.class ("battlemap-manual-controls-" ++ label)),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.DirectionRequested dir)
         )
      ]
      []
   )

go_button : (Html.Html Struct.Event.Type)
go_button =
   (Html.button
      [
         (Html.Attributes.class "battlemap-manual-controls-go"),
         (Html.Events.onClick Struct.Event.AttackWithoutMovingRequest)
      ]
      [
         (Html.text "Go")
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Struct.Event.Type)
get_html =
   (Html.div
      [
         (Html.Attributes.class "battlemap-manual-controls")
      ]
      [
         (direction_button Struct.Direction.Left "left"),
         (direction_button Struct.Direction.Down "down"),
         (direction_button Struct.Direction.Up "up"),
         (direction_button Struct.Direction.Right "right"),
         (go_button)
      ]
   )
