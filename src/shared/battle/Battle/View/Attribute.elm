module Battle.View.Attribute exposing
   (
      get_unsigned_html,
      get_all_unsigned_html,
      get_all_but_gauges_unsigned_html,
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
get_html : (
      Bool ->
      Battle.Struct.Attributes.Category ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_html signed attribute value =
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
               else "omnimod-positive-value"
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
                        if ((value > 0) && signed)
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_signed_html : (
      Battle.Struct.Attributes.Category ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_signed_html attribute value =
   (get_html True attribute value)

get_unsigned_html : (
      Battle.Struct.Attributes.Category ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_unsigned_html attribute value =
   (get_html False attribute value)

get_all_unsigned_html : (
      Battle.Struct.Attributes.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_unsigned_html atts =
   [
      (get_unsigned_html
         Battle.Struct.Attributes.Dodges
         (Battle.Struct.Attributes.get_dodges atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.Parries
         (Battle.Struct.Attributes.get_parries atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.Accuracy
         (Battle.Struct.Attributes.get_accuracy atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.DoubleHits
         (Battle.Struct.Attributes.get_double_hits atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_critical_hits atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.MaxHealth
         (Battle.Struct.Attributes.get_max_health atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.MovementPoints
         (Battle.Struct.Attributes.get_movement_points atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.DamageModifier
         (Battle.Struct.Attributes.get_damage_modifier atts)
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

get_all_but_gauges_unsigned_html : (
      Battle.Struct.Attributes.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_but_gauges_unsigned_html atts =
   [
      (get_unsigned_html
         Battle.Struct.Attributes.Dodges
         (Battle.Struct.Attributes.get_dodges atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.Parries
         (Battle.Struct.Attributes.get_parries atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.Accuracy
         (Battle.Struct.Attributes.get_accuracy atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.DoubleHits
         (Battle.Struct.Attributes.get_double_hits atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_critical_hits atts)
      ),
      (get_unsigned_html
         Battle.Struct.Attributes.CriticalHits
         (Battle.Struct.Attributes.get_critical_hits atts)
      ),
      (get_unsigned_html
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
