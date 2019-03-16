module Battle.View.DamageType exposing
   (
      get_html,
      get_signed_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.DamageTypes

import List

-- Battle ----------------------------------------------------------------------
import Battle.Struct.DamageType

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
      Battle.Struct.DamageType.Type ->
      Int ->
      (List (Html.Html Struct.Event.Type))
   )
get_html damage_type value =
   (Html.div
      [
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.DamageType damage_type)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.DamageTypes.class "omnimod-icon"),
               (Html.DamageTypes.class
                  (
                     "omnimod-icon-"
                     ++ (Battle.Struct.DamageType.encode damage_type)
                  )
               ),
            ]
            [
            ]
         ),
         (Html.div
            [
               (Html.DamageTypes.class "omnimod-value")
            ]
            [
               (Html.text (String.FromInt value))
            ]
         )
      ]
   )

get_signed_html : (
      Battle.Struct.DamageType.Type ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_signed_html damage_type value =
   (Html.div
      [
         (
            if (value < 0)
            then (Html.DamageTypes.class "omnimod-negative")
            else (Html.DamageTypes.class "omnimod-positive")
         ),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.DamageType damage_type)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.DamageTypes.class "omnimod-icon"),
               (Html.DamageTypes.class
                  (
                     "omnimod-icon-"
                     ++ (Battle.Struct.DamageType.encode damage_type)
                  )
               ),
            ]
            [
            ]
         ),
         (Html.div
            [
               (Html.DamageTypes.class "omnimod-value")
            ]
            [
               (Html.text
                  (
                     (
                        if (value < 0)
                        then "-"
                        else "+"
                     )
                     ++ (String.FromInt value)
                  )
               )
            ]
         )
      ]
   )

get_all_html : (
      (List Battle.Struct.DamageTypes.Type) ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_html damage_types =
   (List.map (get_html) damage_types)

get_all_signed_html : (
      (List Battle.Struct.DamageTypes.Type) ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_signed_html damage_types =
   (List.map (get_signed_html) damage_types)
