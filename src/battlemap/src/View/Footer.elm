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

get_curr_char_info_htmls : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      (List (Html.Html Struct.Event.Type))
   )
get_curr_char_info_htmls model char_ref =
   case
      (
         (Dict.get char_ref model.characters),
         (Struct.CharacterTurn.try_getting_navigator model.char_turn)
      )
   of
      ((Just char), (Just nav)) ->
         [
            (Html.text
               (
                  "Controlling "
                  ++ char.name
                  ++ ": "
                  ++ (toString (Struct.Navigator.get_remaining_points nav))
                  ++ "/"
                  ++ (toString (Struct.Character.get_movement_points char))
                  ++ " movement points remaining."
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
