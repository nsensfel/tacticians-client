module Battle.View.Attribute exposing
   (
      get_html,
      get_all_html,
      get_signed_html,
      get_all_signed_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.HelpRequest

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Battle.Struct.Attributes.Category ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_html attribute value =
   (Html.div
      [
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Attribute attribute)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "omnimod-icon"),
               (Html.Attributes.class
                  (
                     "omnimod-icon-"
                     ++ (Battle.Struct.Attributes.encode_category attribute)
                  )
               )
            ]
            [
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-value")
            ]
            [
               (Html.text (String.fromInt value))
            ]
         )
      ]
   )

get_signed_html : (
      Battle.Struct.Attributes.Category ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_signed_html attribute value =
   (Html.div
      [
         (
            if (value < 0)
            then (Html.Attributes.class "omnimod-negative")
            else (Html.Attributes.class "omnimod-positive")
         ),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Attribute attribute)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "omnimod-icon"),
               (Html.Attributes.class
                  (
                     "omnimod-icon-"
                     ++ (Battle.Struct.Attributes.encode_category attribute)
                  )
               )
            ]
            [
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "omnimod-value")
            ]
            [
               (Html.text
                  (
                     if (value > 0)
                     then ("+" ++ (String.fromInt value))
                     else (String.fromInt value)
                  )
               )
            ]
         )
      ]
   )

get_all_html : (
      Battle.Struct.Attributes.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_html atts =
   [
      (get_html
         Battle.Struct.Attributes.Constitution
         (Battle.Struct.Attributes.get_constitution atts)
      ),
      (get_html
         Battle.Struct.Attributes.Strength
         (Battle.Struct.Attributes.get_strength atts)
      ),
      (get_html
         Battle.Struct.Attributes.Dexterity
         (Battle.Struct.Attributes.get_dexterity atts)
      ),
      (get_html
         Battle.Struct.Attributes.Speed
         (Battle.Struct.Attributes.get_speed atts)
      ),
      (get_html
         Battle.Struct.Attributes.Intelligence
         (Battle.Struct.Attributes.get_intelligence atts)
      ),
      (get_html
         Battle.Struct.Attributes.Mind
         (Battle.Struct.Attributes.get_mind atts)
      )
   ]

get_all_signed_html : (
      Battle.Struct.Attributes.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_signed_html atts =
   [
      (get_signed_html
         Battle.Struct.Attributes.Constitution
         (Battle.Struct.Attributes.get_constitution atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Strength
         (Battle.Struct.Attributes.get_strength atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Dexterity
         (Battle.Struct.Attributes.get_dexterity atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Speed
         (Battle.Struct.Attributes.get_speed atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Intelligence
         (Battle.Struct.Attributes.get_intelligence atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Mind
         (Battle.Struct.Attributes.get_mind atts)
      )
   ]
