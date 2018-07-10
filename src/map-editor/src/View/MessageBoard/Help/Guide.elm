module View.MessageBoard.Help.Guide exposing (get_html_contents)

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
get_header_html : (String -> (Html.Html Struct.Event.Type))
get_header_html title =
   (Html.h1
      []
      [
         (Html.div
            [(Html.Attributes.class "battlemap-help-guide-icon")]
            []
         ),
         (Html.text title)
      ]
   )

get_selected_character_html_contents : (List (Html.Html Struct.Event.Type))
get_selected_character_html_contents =
   [
      (get_header_html "Controlling a Character"),
      (Html.text
         (
            "Click on a target tile to select a path or use the manual"
            ++ " controls (on the left panel) to make your own. Click on the"
            ++ " destination tile again to confirm (this can be reverted)."
         )
      )
   ]

get_moved_character_html_contents : (List (Html.Html Struct.Event.Type))
get_moved_character_html_contents =
   [
      (get_header_html "Selecting a Target"),
      (Html.text
         (
            "You can now choose a target in range. Dashed tiles indicate"
            ++ " where your character will not be able to defend themselves"
            ++ " against counter attacks."
         )
      )
   ]

get_chose_target_html_contents : (List (Html.Html Struct.Event.Type))
get_chose_target_html_contents =
   [
      (get_header_html "Finalizing the Character's Turn"),
      (Html.text
         (
            "If you are satisfied with your choices, you can end this"
            ++ " character's turn and see the results unfold. Otherwise, click"
            ++ " on the abort button to undo it all."
         )
      )
   ]

get_default_html_contents : (List (Html.Html Struct.Event.Type))
get_default_html_contents =
   [
      (get_header_html "Selecting a Character"),
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
get_html_contents : (
      Struct.Model.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_html_contents model =
   case (Struct.CharacterTurn.get_state model.char_turn) of
      Struct.CharacterTurn.SelectedCharacter ->
         (get_selected_character_html_contents)

      Struct.CharacterTurn.MovedCharacter ->
         (get_moved_character_html_contents)

      Struct.CharacterTurn.ChoseTarget ->
         (get_chose_target_html_contents)

      _ ->
         (get_default_html_contents)
