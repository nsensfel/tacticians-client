module View.Footer.TabMenu.Status exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Character

import Util.Html

import Error
import Event
import Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
moving_character_text : Model.Type -> String
moving_character_text model =
   case model.selection of
      (Model.SelectedCharacter char_id) ->
         case (Dict.get char_id model.characters) of
            Nothing -> "Error: Unknown character selected."
            (Just char) ->
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

      _ -> "Error: model.selection does not match its state."

get_error_html : Error.Type -> (Html.Html Event.Type)
get_error_html err =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer-tabmenu-status-error-msg")
      ]
      [
         (Html.text (Error.to_string err))
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer-tabmenu-content"),
         (Html.Attributes.class "battlemap-footer-tabmenu-content-status")
      ]
      [
         (case model.error of
            (Just error) -> (get_error_html error)
            Nothing -> Util.Html.nothing
         ),
         (Html.text
            (case model.state of
               Model.Default -> "Click on a character to control it."
               Model.FocusingTile -> "Error: Unimplemented."
               Model.MovingCharacterWithButtons ->
                  (moving_character_text model)

               Model.MovingCharacterWithClick ->
                  (moving_character_text model)
            )
         )
      ]
   )
