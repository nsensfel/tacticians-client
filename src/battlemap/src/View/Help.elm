module View.Help exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_error_message : (
      Struct.Model.Type ->
      Struct.Error.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_error_message model error =
   [(Html.text (Struct.Error.to_string error))]

get_help_message : Struct.Model.Type -> (List (Html.Html Struct.Event.Type))
get_help_message model =
   case (Struct.CharacterTurn.get_state model.char_turn) of
      Struct.CharacterTurn.SelectedCharacter ->
         [
            (Html.text
               (
                  "Click on a target tile to select a path or use the manual"
                  ++ " controls to make your own. Click on the destination tile"
                  ++ " again to confirm."
               )
            )
         ]

      Struct.CharacterTurn.MovedCharacter ->
         [
            (Html.text
               (
                  "You can now choose a target in range. Dashed tiles indicate"
                  ++ " where your character will not be able to defend against"
                  ++ " counter attacks."
               )
            )
         ]

      Struct.CharacterTurn.ChoseTarget ->
         [
            (Html.text
               (
                  "If you are satisfied with your choices, end the turn to"
                  ++ " confirm them."
               )
            )
         ]

      _ ->
         [
            (Html.text
               (
                  "Click once on a character to focus them. This will show you"
                  ++ " their stats, equipment, and other infos. If they are in"
                  ++ " your team and active (the pulsating characters),"
                  ++ " clicking on them again will let you take control."
               )
            )
         ]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case (model.error) of
      (Just error) ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-help"),
               (Html.Attributes.class "battlemap-error")
            ]
            (get_error_message model error)
         )

      Nothing ->
         (Html.div
            [
               (Html.Attributes.class "battlemap-help")
            ]
            (get_help_message model)
         )
