module Battle.View.Help.Statistic exposing (get_html_contents)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Statistics
import Battle.Lang.English

-- Local Module ----------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_header_html : (
      Battle.Struct.Statistics.Category ->
      String ->
      (Html.Html Struct.Event.Type)
   )
get_header_html cat name =
   (Html.h1
      []
      [
         (Html.div
            [(Html.Attributes.class "help-guide-icon")]
            []
         ),
         (Html.text " "),
         (Html.div
            [
               (Html.Attributes.class "omnimod-icon"),
               (Html.Attributes.class
                  (
                     "omnimod-icon-"
                     ++ (Battle.Struct.Statistics.encode_category cat)
                  )
               )
            ]
            [
            ]
         ),
         (Html.text name)
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html_contents : (
      Battle.Struct.Statistics.Category ->
      (List (Html.Html Struct.Event.Type))
   )
get_html_contents cat =
   let
      (name, tooltip) = (Battle.Lang.English.get_statistic_category_help cat)
   in
   [
      (get_header_html cat name),
      tooltip
   ]
