module View.SideBar.ManualControls exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap -------------------------------------------------------------------
import Battlemap.Direction

import Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
direction_button : Battlemap.Direction.Type -> String -> (Html.Html Event.Type)
direction_button dir label =
   (Html.button
      [
         (Html.Events.onClick
            (Event.DirectionRequested dir)
         )
      ]
      [ (Html.text label) ]
   )

end_turn_button : (Html.Html Event.Type)
end_turn_button =
   (Html.button
      [ (Html.Events.onClick Event.TurnEnded) ]
      [ (Html.text "End Turn") ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (Html.Html Event.Type)
get_html =
   (Html.div
      [
         (Html.Attributes.class "battlemap-manual-controls")
      ]
      [
         (direction_button Battlemap.Direction.Left "Left"),
         (direction_button Battlemap.Direction.Down "Down"),
         (direction_button Battlemap.Direction.Up "Up"),
         (direction_button Battlemap.Direction.Right "Right"),
         (end_turn_button)
      ]
   )
