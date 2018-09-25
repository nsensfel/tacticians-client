module View.MessageBoard.Help.Guide exposing (get_html_contents)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Map -------------------------------------------------------------------
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
            [(Html.Attributes.class "help-guide-icon")]
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
      (get_header_html "Selecting an Action"),
      (Html.text
         (
            """You can now choose an action for this character. Either attack
 a target in range by clicking twice on it, or switch weapons by using the menu
 on the left. Dashes indicate tiles this character will be unable to defend
 from. Crossed shields indicate the equivalent for the current selection."""
         )
      )
   ]

get_chose_target_html_contents : (List (Html.Html Struct.Event.Type))
get_chose_target_html_contents =
   [
      (get_header_html "End the Turn by an Attack"),
      (Html.text
         (
            """A target for the attack has been selected. If you are satisfied
with your choices, you can end this character's turn and see the results unfold.
Otherwise, click on the "Undo" button to change the action, or the "Abort"
button to start this turn over."""
         )
      )
   ]

get_switched_weapons_html_contents : (List (Html.Html Struct.Event.Type))
get_switched_weapons_html_contents =
   [
      (get_header_html "End the Turn by Switching Weapons"),
      (Html.text
         (
            """The character will switch weapons. If you are satisfied
with your choices, you can end this character's turn and see the results unfold.
Otherwise, click on the "Undo" button to change the action, or the "Abort"
button to start this turn over."""
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

      Struct.CharacterTurn.SwitchedWeapons ->
         (get_switched_weapons_html_contents)

      _ ->
         (get_default_html_contents)
