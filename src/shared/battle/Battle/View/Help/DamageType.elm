module Battle.View.Help.DamageType exposing (get_html_contents)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battle ----------------------------------------------------------------------
import Battle.Struct.DamageType
import Battle.Lang.English

-- Local Module ----------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_header_html : (
      Battle.Struct.DamageType.Type ->
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
                     ++ (Battle.Struct.DamageType.encode cat)
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
      Battle.Struct.DamageType.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_html_contents cat =
   let
      (name, tooltip) = (Battle.Lang.English.get_damage_type_help cat)
   in
   [
      (get_header_html cat name),
      tooltip
   ]
