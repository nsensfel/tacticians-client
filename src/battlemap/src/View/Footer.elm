module View.Footer exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.UI

import Util.Html

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
end_turn_button : (Html.Html Struct.Event.Type)
end_turn_button =
   (Html.button
      [ (Html.Events.onClick Struct.Event.TurnEnded) ]
      [ (Html.text "End Turn") ]
   )

inventory_button : (Html.Html Struct.Event.Type)
inventory_button =
   (Html.button
      [ ]
      [ (Html.text "Switch Weapon") ]
   )

get_navigator_info : (
      Struct.Model.Type ->
      Struct.Character.Type->
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
            ++ (toString (Struct.Character.get_movement_points char))
            ++ " movement points remaining"
         )

      _ ->
         "[Error: Unknown character selected.]"

get_curr_char_info_htmls : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      (List (Html.Html Struct.Event.Type))
   )
get_curr_char_info_htmls model char_ref =
   case
      (
         (Struct.CharacterTurn.get_state model.char_turn),
         (Dict.get char_ref model.characters)
      )
   of
      (Struct.CharacterTurn.SelectedCharacter, (Just char)) ->
         [
            (Html.text
               (
                  "Controlling "
                  ++ char.name
                  ++ ". Move ("
                  ++ (get_navigator_info model char)
                  ++ ") or "
               )
            ),
            (inventory_button)
         ]

      (Struct.CharacterTurn.MovedCharacter, (Just char)) ->
         [
            (Html.text
               (
                  "Controlling "
                  ++ char.name
                  ++ ". Moved. Select targets or "
               )
            ),
            (end_turn_button)
         ]

      (Struct.CharacterTurn.ChoseTarget, (Just char)) ->
         [
            (Html.text
               (
                  "Controlling "
                  ++ char.name
                  ++ ". Moved. Chose target(s). Select additional targets or "
               )
            ),
            (end_turn_button)
         ]

      (_, _) ->
         [(Html.text "Error: Unknown character selected.")]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case
      (Struct.CharacterTurn.try_getting_controlled_character model.char_turn)
   of
      (Just char_id) ->
         (Html.div
            [(Html.Attributes.class "battlemap-footer")]
            (get_curr_char_info_htmls model char_id)
         )

      Nothing -> (Util.Html.nothing)
