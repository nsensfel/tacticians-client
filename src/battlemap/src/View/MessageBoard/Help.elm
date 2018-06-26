module View.MessageBoard.Help exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.CharacterTurn
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
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
   (Html.div
      [
         (Html.Attributes.class "battlemap-message-board")
      ]
      (get_help_message model)
   )
