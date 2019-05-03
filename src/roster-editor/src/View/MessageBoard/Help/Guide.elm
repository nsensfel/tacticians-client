module View.MessageBoard.Help.Guide exposing (get_html_contents)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Local Module ----------------------------------------------------------------
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


get_default_html_contents : (List (Html.Html Struct.Event.Type))
get_default_html_contents =
   [
      (get_header_html "Modifying the Character Roster"),
      (Html.text "The guide for this module is not yet available.")
   ]

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html_contents : (
      Struct.Model.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_html_contents model = (get_default_html_contents)
