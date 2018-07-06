module View.MessageBoard.Help exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.HelpRequest
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_rank_help_message : (
      Struct.Character.Rank ->
      (List (Html.Html Struct.Event.Type))
   )
get_rank_help_message rank =
   case rank of
      Struct.Character.Target ->
         [
            (Html.h1 [] [(Html.text "Protected Character")]),
            (Html.div
               [
                  (Html.Attributes.class
                     "battlemap-character-card-target-status"
                  )
               ]
               []
            ),
            (Html.text
               (
                  "Players that lost all of their Protected characters are"
                  ++ " eliminated."
               )
            )
         ]

      Struct.Character.Commander ->
         [
            (Html.h1 [] [(Html.text "Critical Character")]),
            (Html.div
               [
                  (Html.Attributes.class
                     "battlemap-character-card-commander-status"
                  )
               ]
               []
            ),
            (Html.text
               (
                  "Players that lost any of their Critical characters are"
                  ++ " eliminated."
               )
            )
         ]

      Struct.Character.Optional ->
         [
            (Html.h1 [] [(Html.text "Reinforcement Character")]),
            (Html.text
               (
                  "Unless it is their last character, losing Reinforcement"
                  ++ " characters does not cause a player to be eliminated."
               )
            )
         ]

get_default_help_message : (
      Struct.Model.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_default_help_message model =
   case (Struct.CharacterTurn.get_state model.char_turn) of
      Struct.CharacterTurn.SelectedCharacter ->
         [
            (Html.h1 [] [(Html.text "Character Selected")]),
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
            (Html.h1 [] [(Html.text "Character Moved")]),
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
            (Html.h1 [] [(Html.text "Target Selected")]),
            (Html.text
               (
                  "If you are satisfied with your choices, end the turn to"
                  ++ " confirm them."
               )
            )
         ]

      _ ->
         [
            (Html.h1 [] [(Html.text "Selecting Character")]),
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
      (
         case model.help_request of
            Struct.HelpRequest.None -> (get_default_help_message model)
            (Struct.HelpRequest.HelpOnRank rank) -> (get_rank_help_message rank)
      )
   )
