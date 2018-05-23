module View.SubMenu.Timeline.WeaponSwitch exposing (get_html)

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
      Struct.TurnResult.WeaponSwitch ->
      (Html.Html Struct.Event.Type)
   )
get_html model weapon_switch =
   case (Dict.get (toString weapon_switch.character_index) model.characters) of
      (Just char) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-weapon-switch")
            ]
            [
               (View.Character.get_portrait_html model.player_id char),
               (Html.text
                  (
                     (Struct.Character.get_name char)
                     ++ " switched weapons."
                  )
               )
            ]
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-timeline-element"),
               (Html.Attributes.class "battlemap-timeline-weapon-switch")
            ]
            [
               (Html.text "Error: Unknown character switched weapons")
            ]
         )
