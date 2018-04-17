module View.SideBar.TabMenu.Timeline.Movement exposing (get_html)

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

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_portrait_html : (
      String ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_portrait_html viewer_id char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-timeline-portrait"),
         (Html.Attributes.class
            (
               if ((Struct.Character.get_player_id char) == viewer_id)
               then
                  "battlemap-character-ally"
               else
                  "battlemap-character-enemy"
            )
         ),
         (Html.Attributes.class
            (
               "asset-character-portrait-"
               ++ (Struct.Character.get_portrait_id char)
            )
         )
      ]
      [
      ]
   )

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
               (get_portrait_html model.player_id char),
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
