module View.MessageBoard.Help.Rank exposing (get_html_contents)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Map -------------------------------------------------------------------
import Struct.Character
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_guide_icon_html : (Html.Html Struct.Event.Type)
get_guide_icon_html =
   (Html.div
      [(Html.Attributes.class "help-guide-icon")]
      []
   )

get_header_with_icon_html : String -> String -> (Html.Html Struct.Event.Type)
get_header_with_icon_html title rank_name =
   (Html.h1
      []
      [
         (get_guide_icon_html),
         (Html.text (title ++ " - ")),
         (Html.div
            [
               (Html.Attributes.class
                  "message-board-help-figure"
               ),
               (Html.Attributes.class
                  ("character-card-" ++ rank_name ++ "-status")
               )
            ]
            []
         )
      ]
   )

get_target_help_message : (List (Html.Html Struct.Event.Type))
get_target_help_message =
   [
      (get_header_with_icon_html "Protected Character" "target"),
      (Html.text
         (
            "Players that lose all of their Protected Characters are"
            ++ " eliminated."
         )
      )
   ]

get_commander_help_message : (List (Html.Html Struct.Event.Type))
get_commander_help_message =
   [
      (get_header_with_icon_html "Critical Character" "commander"),
      (Html.text
         (
            "Players that lose any of their Critical Characters are"
            ++ " eliminated."
         )
      )
   ]

get_optional_help_message : (List (Html.Html Struct.Event.Type))
get_optional_help_message =
   [
      (Html.h1
         []
         [
            (get_guide_icon_html),
            (Html.text "Reinforcement Character")
         ]
      ),
      (Html.text
         (
            "Unless it is their very last character, losing a"
            ++ " Reinforcement characters never causes a player to be"
            ++ " eliminated."
         )
      )
   ]


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html_contents : (
      Struct.Character.Rank ->
      (List (Html.Html Struct.Event.Type))
   )
get_html_contents rank =
   case rank of
      Struct.Character.Target -> (get_target_help_message)
      Struct.Character.Commander -> (get_commander_help_message)
      Struct.Character.Optional -> (get_optional_help_message)
