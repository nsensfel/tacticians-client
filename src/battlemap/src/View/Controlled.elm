module View.Controlled exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.WeaponSet

import Util.Html

import View.Controlled.CharacterCard

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
attack_button : (Html.Html Struct.Event.Type)
attack_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.AttackWithoutMovingRequest) ]
      [ (Html.text "Select Target") ]
   )

end_turn_button : (Html.Html Struct.Event.Type)
end_turn_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.TurnEnded) ]
      [ (Html.text "End Turn") ]
   )

inventory_button : (Html.Html Struct.Event.Type)
inventory_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.WeaponSwitchRequest) ]
      [ (Html.text "Switch Weapon") ]
   )

get_available_actions : (
      Struct.Model.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_available_actions model =
   case (Struct.CharacterTurn.get_state model.char_turn) of
      Struct.CharacterTurn.SelectedCharacter ->
         [
            (attack_button),
            (inventory_button)
         ]

      Struct.CharacterTurn.MovedCharacter ->
         [
            (end_turn_button)
         ]

      Struct.CharacterTurn.ChoseTarget ->
         [
            (end_turn_button)
         ]

      _ ->
         [
         ]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case
      (Struct.CharacterTurn.try_getting_active_character model.char_turn)
   of
      (Just char) ->
         (Html.div
            [(Html.Attributes.class "battlemap-controlled")]
            [
               (View.Controlled.CharacterCard.get_html
                  model
                  char
                  (Struct.WeaponSet.get_active_weapon
                     (Struct.Character.get_weapons char)
                  )
               ),
               (Html.div
                  [(Html.Attributes.class "battlemap-controlled-actions")]
                  (get_available_actions model)
               )
            ]
         )

      Nothing -> (Util.Html.nothing)
