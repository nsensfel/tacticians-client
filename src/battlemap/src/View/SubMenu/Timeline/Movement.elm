module View.SubMenu.Timeline.Movement exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
--import Html.Events

-- Battlemap -------------------------------------------------------------------
import Struct.Event
import Struct.TurnResult
import Struct.Character
import Struct.Model

import View.Character

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.TurnResult.Movement ->
      (Html.Html Struct.Event.Type)
   )
get_html model movement =
   case (Dict.get (toString movement.character_index) model.characters) of
      (Just char) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-movement")
            ]
            [
               (View.Character.get_portrait_html model.player_id char),
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
