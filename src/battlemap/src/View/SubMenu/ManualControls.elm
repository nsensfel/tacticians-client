module View.SideBar.ManualControls exposing (get_html)

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
   (Html.button
      [
         (Html.Events.onClick
            (Struct.Event.DirectionRequested dir)
         )
      ]
      [ (Html.text label) ]
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
         (direction_button Struct.Direction.Left "Left"),
         (direction_button Struct.Direction.Down "Down"),
         (direction_button Struct.Direction.Up "Up"),
         (direction_button Struct.Direction.Right "Right")
      ]
   )
