module Battle.View.DamageType exposing
   (
      get_unsigned_html,
      get_signed_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

import List

-- Battle ----------------------------------------------------------------------
import Battle.Struct.DamageType

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.HelpRequest

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Bool ->
      Battle.Struct.DamageType.Type ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_html signed damage_type value =
   (Html.div
      [
         (Html.Attributes.class
            (
               if (value < 0)
               then "omnimod-negative-value"
               else "omnimod-positive-value"
            )
         ),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.DamageType damage_type)
            )
         ),
         (Html.Attributes.class "omnimod-icon"),
         (Html.Attributes.class
            (
               "omnimod-icon-"
               ++ (Battle.Struct.DamageType.encode damage_type)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "omnimod-value")
            ]
            [
               (Html.text
                  (
                     if ((value > 0) && signed)
                     then ("+" ++ (String.fromInt value))
                     else (String.fromInt value)
                  )
               )
            ]
         )
      ]
   )


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_unsigned_html : (
      Battle.Struct.DamageType.Type ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_unsigned_html damage_type value =
   (get_html False damage_type value)

get_signed_html : (
      Battle.Struct.DamageType.Type ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_signed_html damage_type value =
   (get_html True damage_type value)
