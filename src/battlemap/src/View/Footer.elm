module View.Footer exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

import Dict

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Character

import Event

import Model

import Util.Html

import UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_curr_char_info_htmls : (
      Model.Type ->
      Character.Ref ->
      (List (Html.Html Event.Type))
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
                        (Battlemap.get_navigator_remaining_points
                           model.battlemap
                        )
                     )
                  ++ "/"
                  ++ (toString (Character.get_movement_points char))
                  ++ " movement points remaining."
               )
            )
         ]

      Nothing ->
         [(Html.text "Error: Unknown character selected.")]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   case model.controlled_character of
      (Just char_id) ->
         (Html.div
            [(Html.Attributes.class "battlemap-footer")]
            (get_curr_char_info_htmls model char_id)
         )

      Nothing -> (Util.Html.nothing)
