module View.Controls exposing (view)

import Html
import Html.Events

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

scale_button : Float -> String -> (Html.Html Event.Type)
scale_button mod label =
   (Html.button
      [
         (Html.Events.onClick
            (Event.ScaleChangeRequested mod)
         )
      ]
      [ (Html.text label) ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
view : (List (Html.Html Event.Type))
view =
   [
      (direction_button Battlemap.Direction.Left "Left"),
      (direction_button Battlemap.Direction.Down "Down"),
      (direction_button Battlemap.Direction.Up "Up"),
      (direction_button Battlemap.Direction.Right "Right"),
      (end_turn_button),
      (scale_button (0.75) "Zoom -"),
      (scale_button 0 "Zoom Reset"),
      (scale_button (1.15) "Zoom +")
   ]
