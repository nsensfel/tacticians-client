module Battle.View.DamageType exposing
   (
      get_html,
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Battle.Struct.DamageType.Type ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_html damage_type value =
   (Html.div
      [
         (Html.Attributes.class "omnimod-icon"),
         (Html.Attributes.class
            (
               "omnimod-icon-"
               ++ (Battle.Struct.DamageType.encode damage_type)
            )
         ),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.DamageType damage_type)
            )
         )
      ]
      [
         (Html.text (String.fromInt value))
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
            then (Html.Attributes.class "omnimod-negative")
            else (Html.Attributes.class "omnimod-positive")
         ),
         (Html.Attributes.class "omnimod-icon"),
         (Html.Attributes.class
            (
               "omnimod-icon-"
               ++ (Battle.Struct.DamageType.encode damage_type)
            )
         ),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.DamageType damage_type)
            )
         )
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

get_all_html : (
      (List (Battle.Struct.DamageType.Type, Int)) ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_html damage_types =
   (List.map (\(d, v) -> (get_html d v)) damage_types)

get_all_signed_html : (
      (List (Battle.Struct.DamageType.Type, Int)) ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_signed_html damage_types =
   (List.map (\(d, v) -> (get_signed_html d v)) damage_types)
