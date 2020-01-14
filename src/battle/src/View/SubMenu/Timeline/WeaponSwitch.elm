module View.SubMenu.Timeline.WeaponSwitch exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character

-- Local Module ----------------------------------------------------------------
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
      Struct.TurnResult.WeaponSwitch ->
      (Html.Html Struct.Event.Type)
   )
get_html characters player_ix weapon_switch =
   case (Array.get weapon_switch.character_index characters) of
      (Just char) ->
         (Html.div
            [
               (Html.Attributes.class "timeline-element"),
               (Html.Attributes.class "timeline-weapon-switch")
            ]
            [
               (View.Character.get_portrait_html char),
               (Html.text
                  (
                     (BattleCharacters.Struct.Character.get_name
                        (Struct.Character.get_base_character char)
                     )
                     ++ " switched weapons."
                  )
               )
            ]
         )

      _ ->
         (Html.div
            [
               (Html.Attributes.class "timeline-element"),
               (Html.Attributes.class "timeline-weapon-switch")
            ]
            [
               (Html.text "Error: Unknown character switched weapons")
            ]
         )
