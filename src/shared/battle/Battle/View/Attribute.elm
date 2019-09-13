module Battle.View.Attribute exposing
   (
      get_html,
      get_all_html,
      get_true_all_html,
      get_all_but_gauges_html,
      get_signed_html,
      get_all_signed_html,
      get_all_but_gauges_signed_html
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
         ),
         (Html.Attributes.class
            (
               if (value < 0)
               then "omnimod-negative-value"
               else
                  if (value > 0)
                  then "omnimod-positive-value"
                  else "omnimod-nil-value"
            )
         ),
         (Html.Attributes.class "omnimod-icon"),
         (Html.Attributes.class
            (
               "omnimod-icon-"
               ++ (Battle.Struct.Attributes.encode_category attribute)
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
                     if (Battle.Struct.Attributes.is_percent attribute)
                     then ((String.fromInt value) ++ "%")
                     else (String.fromInt value)
                  )
               )
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
         ),
         (Html.Attributes.class "omnimod-icon"),
         (Html.Attributes.class
            (
               "omnimod-icon-"
               ++ (Battle.Struct.Attributes.encode_category attribute)
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
                     (
                        if (value > 0)
                        then ("+" ++ (String.fromInt value))
                        else (String.fromInt value)
                     )
                     ++
                     (
                        if (Battle.Struct.Attributes.is_percent attribute)
                        then "%"
                        else ""
                     )
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
         Battle.Struct.Attributes.Dodges
         (Battle.Struct.Attributes.get_dodges atts)
      ),
      (get_html
         Battle.Struct.Attributes.Parries
         (Battle.Struct.Attributes.get_parries atts)
      ),
      (get_html
         Battle.Struct.Attributes.Accuracy
         (Battle.Struct.Attributes.get_accuracy atts)
      ),
      (get_html
         Battle.Struct.Attributes.DoubleHits
         (Battle.Struct.Attributes.get_double_hits atts)
      ),
      (get_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_critical_hits atts)
      ),
      (get_html
         Battle.Struct.Attributes.MaxHealth
         (Battle.Struct.Attributes.get_max_health atts)
      ),
      (get_html
         Battle.Struct.Attributes.MovementPoints
         (Battle.Struct.Attributes.get_movement_points atts)
      ),
      (get_html
         Battle.Struct.Attributes.DamageModifier
         (Battle.Struct.Attributes.get_damage_modifier atts)
      )
   ]

get_true_all_html : (
      Battle.Struct.Attributes.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_true_all_html atts =
   [
      (get_html
         Battle.Struct.Attributes.Dodges
         (Battle.Struct.Attributes.get_true_dodges atts)
      ),
      (get_html
         Battle.Struct.Attributes.Parries
         (Battle.Struct.Attributes.get_true_parries atts)
      ),
      (get_html
         Battle.Struct.Attributes.Accuracy
         (Battle.Struct.Attributes.get_true_accuracy atts)
      ),
      (get_html
         Battle.Struct.Attributes.DoubleHits
         (Battle.Struct.Attributes.get_true_double_hits atts)
      ),
      (get_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_true_critical_hits atts)
      ),
      (get_html
         Battle.Struct.Attributes.MaxHealth
         (Battle.Struct.Attributes.get_true_max_health atts)
      ),
      (get_html
         Battle.Struct.Attributes.MovementPoints
         (Battle.Struct.Attributes.get_true_movement_points atts)
      ),
      (get_html
         Battle.Struct.Attributes.DamageModifier
         (Battle.Struct.Attributes.get_true_damage_modifier atts)
      )
   ]

get_all_signed_html : (
      Battle.Struct.Attributes.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_signed_html atts =
   [
      (get_signed_html
         Battle.Struct.Attributes.Dodges
         (Battle.Struct.Attributes.get_dodges atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Parries
         (Battle.Struct.Attributes.get_parries atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Accuracy
         (Battle.Struct.Attributes.get_accuracy atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.DoubleHits
         (Battle.Struct.Attributes.get_double_hits atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_critical_hits atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.MaxHealth
         (Battle.Struct.Attributes.get_max_health atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.MovementPoints
         (Battle.Struct.Attributes.get_movement_points atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.DamageModifier
         (Battle.Struct.Attributes.get_damage_modifier atts)
      )
   ]

get_all_but_gauges_html : (
      Battle.Struct.Attributes.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_but_gauges_html atts =
   [
      (get_html
         Battle.Struct.Attributes.Dodges
         (Battle.Struct.Attributes.get_dodges atts)
      ),
      (get_html
         Battle.Struct.Attributes.Parries
         (Battle.Struct.Attributes.get_parries atts)
      ),
      (get_html
         Battle.Struct.Attributes.Accuracy
         (Battle.Struct.Attributes.get_accuracy atts)
      ),
      (get_html
         Battle.Struct.Attributes.DoubleHits
         (Battle.Struct.Attributes.get_double_hits atts)
      ),
      (get_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_critical_hits atts)
      ),
      (get_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_critical_hits atts)
      ),
      (get_html
         Battle.Struct.Attributes.DamageModifier
         (Battle.Struct.Attributes.get_damage_modifier atts)
      )
   ]

get_all_but_gauges_signed_html : (
      Battle.Struct.Attributes.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_but_gauges_signed_html atts =
   [
      (get_signed_html
         Battle.Struct.Attributes.Dodges
         (Battle.Struct.Attributes.get_dodges atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Parries
         (Battle.Struct.Attributes.get_parries atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.Accuracy
         (Battle.Struct.Attributes.get_accuracy atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.DoubleHits
         (Battle.Struct.Attributes.get_double_hits atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_critical_hits atts)
      ),
      (get_signed_html
         Battle.Struct.Attributes.DamageModifier
         (Battle.Struct.Attributes.get_damage_modifier atts)
      )
   ]
