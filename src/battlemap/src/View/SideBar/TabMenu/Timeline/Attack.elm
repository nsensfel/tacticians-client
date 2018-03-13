module View.SideBar.TabMenu.Timeline.Attack exposing (get_html)

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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.TurnResult.Attack ->
      (Html.Html Struct.Event.Type)
   )
get_html model attack =
   case
      (
         (Dict.get (toString attack.attacker_index) model.characters),
         (Dict.get (toString attack.defender_index) model.characters)
      )
   of
      ((Just atkchar), (Just defchar)) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-attack")
            ]
            [
               (Html.text
                  (
                     (Struct.Character.get_name atkchar)
                     ++ " attacked "
                     ++ (Struct.Character.get_name defchar)
                     ++ "!"
                  )
               )
            ]
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-attack")
            ]
            [
               (Html.text "Error: Attack with unknown characters")
            ]
         )
