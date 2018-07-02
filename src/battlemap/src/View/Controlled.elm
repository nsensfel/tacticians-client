module View.Controlled exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Event
import Struct.Navigator

import Util.Html

import View.Controlled.CharacterCard
import View.Controlled.ManualControls

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
has_a_path : Struct.CharacterTurn.Type -> Bool
has_a_path char_turn =
   case (Struct.CharacterTurn.try_getting_navigator char_turn) of
      (Just nav) -> ((Struct.Navigator.get_path nav) /= [])
      Nothing -> False


attack_button : Struct.CharacterTurn.Type -> (Html.Html Struct.Event.Type)
attack_button char_turn =
   (Html.button
      [ (Html.Events.onClick Struct.Event.AttackWithoutMovingRequest) ]
      [
         (Html.text
            (
               if (has_a_path char_turn)
               then ("Go & Select Target")
               else ("Select Target")
            )
         )
      ]
   )

abort_button : (Html.Html Struct.Event.Type)
abort_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.AbortTurnRequest) ]
      [ (Html.text "Abort") ]
   )

end_turn_button : String -> (Html.Html Struct.Event.Type)
end_turn_button suffix =
   (Html.button
      [
         (Html.Events.onClick Struct.Event.TurnEnded),
         (Html.Attributes.class "battlemap-end-turn-button")
      ]
      [ (Html.text ("End Turn" ++ suffix)) ]
   )

inventory_button : (Html.Html Struct.Event.Type)
inventory_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.WeaponSwitchRequest) ]
      [ (Html.text "Switch Weapon") ]
   )

get_available_actions : (
      Struct.CharacterTurn.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_available_actions char_turn =
   case (Struct.CharacterTurn.get_state char_turn) of
      Struct.CharacterTurn.SelectedCharacter ->
         [
            (attack_button char_turn),
            (inventory_button),
            (end_turn_button " Doing Nothing"),
            (abort_button)
         ]

      Struct.CharacterTurn.MovedCharacter ->
         [
            (end_turn_button " Without Attacking"),
            (abort_button)
         ]

      Struct.CharacterTurn.ChoseTarget ->
         [
            (end_turn_button " By Attacking"),
            (abort_button)
         ]

      _ ->
         [
         ]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.CharacterTurn.Type -> Int -> (Html.Html Struct.Event.Type)
get_html char_turn player_ix =
   case
      (Struct.CharacterTurn.try_getting_active_character char_turn)
   of
      (Just char) ->
         (Html.div
            [(Html.Attributes.class "battlemap-controlled")]
            [
               (View.Controlled.CharacterCard.get_summary_html
                  char_turn
                  player_ix
                  char
               ),
               (
                  if
                  (
                     (Struct.CharacterTurn.get_state char_turn)
                     ==
                     Struct.CharacterTurn.SelectedCharacter
                  )
                  then
                     (View.Controlled.ManualControls.get_html)
                  else
                     (Util.Html.nothing)
               ),
               (Html.div
                  [(Html.Attributes.class "battlemap-controlled-actions")]
                  (get_available_actions char_turn)
               )
            ]
         )

      Nothing -> (Util.Html.nothing)
