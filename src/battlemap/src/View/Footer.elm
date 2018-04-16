module View.Footer exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.Statistics

import Util.Html

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
attack_button : (Html.Html Struct.Event.Type)
attack_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.AttackWithoutMovingRequest) ]
      [ (Html.text "Attack Without Moving") ]
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

get_navigator_info : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      String
   )
get_navigator_info model char =
   case
      (Struct.CharacterTurn.try_getting_navigator model.char_turn)
   of
      (Just nav) ->
         (
            (toString (Struct.Navigator.get_remaining_points nav))
            ++ "/"
            ++
            (toString
               (Struct.Statistics.get_movement_points
                  (Struct.Character.get_statistics char)
               )
            )
            ++ " movement points remaining"
         )

      _ ->
         "[Error: Character selected yet navigator undefined.]"

get_curr_char_info_htmls : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_curr_char_info_htmls model char =
   case
      (Struct.CharacterTurn.get_state model.char_turn)
   of
      Struct.CharacterTurn.SelectedCharacter ->
         [
            (Html.text
               (
                  "Controlling "
                  ++ char.name
                  ++ ". Move ("
                  ++ (get_navigator_info model char)
                  ++ "), "
               )
            ),
            (attack_button),
            (Html.text ", or "),
            (inventory_button)
         ]

      Struct.CharacterTurn.MovedCharacter ->
         [
            (Html.text
               (
                  "Controlling "
                  ++ char.name
                  ++ ". Moved. Select a target, or "
               )
            ),
            (end_turn_button)
         ]

      Struct.CharacterTurn.ChoseTarget ->
         [
            (Html.text
               (
                  "Controlling "
                  ++ char.name
                  ++ ". Moved. Chose a target. Click on "
               )
            ),
            (end_turn_button),
            (Html.text "to end turn.")
         ]

      _ ->
         [
            (Html.text
               (
                  "Error: CharacterTurn structure in an inconsistent state:"
                  ++ " Has an active character yet the 'state' is not any of"
                  ++ " those expected in such cases."
               )
            )
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
            [(Html.Attributes.class "battlemap-footer")]
            (get_curr_char_info_htmls model char)
         )

      Nothing -> (Util.Html.nothing)
