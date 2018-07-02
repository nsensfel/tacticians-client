module View.SubMenu.Timeline.Movement exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
--import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.TurnResult
import Struct.Character

import View.Character

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      (Array.Array Struct.Character.Type) ->
      Int ->
      Struct.TurnResult.Movement ->
      (Html.Html Struct.Event.Type)
   )
get_html characters player_ix movement =
   case (Array.get movement.character_index characters) of
      (Just char) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-movement")
            ]
            [
               (View.Character.get_portrait_html player_ix char),
               (Html.text
                  (
                     (Struct.Character.get_name char)
                     ++ " moved to ("
                     ++ (toString movement.destination.x)
                     ++ ", "
                     ++ (toString movement.destination.y)
                     ++ ")."
                  )
               )
            ]
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-movement")
            ]
            [
               (Html.text "Error: Moving with unknown character")
            ]
         )
