module View.Controls exposing (view)

import Html
import Html.Events

import Battlemap.Direction

import Update

direction_button : Battlemap.Direction.Type -> String -> (Html.Html Update.Type)
direction_button dir label =
   (Html.button
      [
         (Html.Events.onClick
            (Update.DirectionRequest dir)
         )
      ]
      [ (Html.text label) ]
   )

end_turn_button : (Html.Html Update.Type)
end_turn_button =
   (Html.button
      [ (Html.Events.onClick Update.EndTurn) ]
      [ (Html.text "End Turn") ]
   )

view : (List (Html.Html Update.Type))
view =
   [
      (direction_button Battlemap.Direction.Left "Left"),
      (direction_button Battlemap.Direction.Down "Down"),
      (direction_button Battlemap.Direction.Up "Up"),
      (direction_button Battlemap.Direction.Right "Right"),
      (end_turn_button)
   ]
