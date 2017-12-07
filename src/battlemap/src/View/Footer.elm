module View.Footer exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.UI

import Util.Html

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_curr_char_info_htmls : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      (List (Html.Html Struct.Event.Type))
   )
get_curr_char_info_htmls model char_ref =
   case (Dict.get char_ref model.characters) of
      (Just char) ->
         [
            (Html.text
               (
                  "Controlling "
                  ++ char.name
                  ++ ": "
                  ++ (toString
--                        (Struct.Battlemap.get_navigator_remaining_points
--                           model.battlemap
--                        )
                        0
                     )
                  ++ "/"
                  ++ (toString (Struct.Character.get_movement_points char))
                  ++ " movement points remaining."
               )
            )
         ]

      Nothing ->
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
