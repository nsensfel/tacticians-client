module Battle.View.Statistic exposing
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
import Battle.Struct.Statistics

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
      Battle.Struct.Statistics.Category ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_html statistic value =
   (Html.div
      [
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Statistic statistic)
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
                     ++ (Battle.Struct.Statistics.encode_category statistic)
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
                     if (Battle.Struct.Statistics.is_percent statistic)
                     then ((String.fromInt value) ++ "%")
                     else (String.fromInt value)
                  )
               )
            ]
         )
      ]
   )

get_signed_html : (
      Battle.Struct.Statistics.Category ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_signed_html statistic value =
   (Html.div
      [
         (
            if (value < 0)
            then (Html.Attributes.class "omnimod-negative")
            else (Html.Attributes.class "omnimod-positive")
         ),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Statistic statistic)
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
                     ++ (Battle.Struct.Statistics.encode_category statistic)
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
                     (
                        if (value > 0)
                        then ("+" ++ (String.fromInt value))
                        else (String.fromInt value)
                     )
                     ++
                     (
                        if (Battle.Struct.Statistics.is_percent statistic)
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
      Battle.Struct.Statistics.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_html stats =
   [
      (get_html
         Battle.Struct.Statistics.Dodges
         (Battle.Struct.Statistics.get_dodges stats)
      ),
      (get_html
         Battle.Struct.Statistics.Parries
         (Battle.Struct.Statistics.get_parries stats)
      ),
      (get_html
         Battle.Struct.Statistics.Accuracy
         (Battle.Struct.Statistics.get_accuracy stats)
      ),
      (get_html
         Battle.Struct.Statistics.DoubleHits
         (Battle.Struct.Statistics.get_double_hits stats)
      ),
      (get_html
         Battle.Struct.Statistics.CriticalHits
         (Battle.Struct.Statistics.get_critical_hits stats)
      ),
      (get_html
         Battle.Struct.Statistics.MaxHealth
         (Battle.Struct.Statistics.get_max_health stats)
      ),
      (get_html
         Battle.Struct.Statistics.MovementPoints
         (Battle.Struct.Statistics.get_movement_points stats)
      )
   ]

get_all_signed_html : (
      Battle.Struct.Statistics.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_signed_html stats =
   [
      (get_signed_html
         Battle.Struct.Statistics.Dodges
         (Battle.Struct.Statistics.get_dodges stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.Parries
         (Battle.Struct.Statistics.get_parries stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.Accuracy
         (Battle.Struct.Statistics.get_accuracy stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.DoubleHits
         (Battle.Struct.Statistics.get_double_hits stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.CriticalHits
         (Battle.Struct.Statistics.get_critical_hits stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.MaxHealth
         (Battle.Struct.Statistics.get_max_health stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.MovementPoints
         (Battle.Struct.Statistics.get_movement_points stats)
      )
   ]

get_all_but_gauges_html : (
      Battle.Struct.Statistics.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_but_gauges_html stats =
   [
      (get_html
         Battle.Struct.Statistics.Dodges
         (Battle.Struct.Statistics.get_dodges stats)
      ),
      (get_html
         Battle.Struct.Statistics.Parries
         (Battle.Struct.Statistics.get_parries stats)
      ),
      (get_html
         Battle.Struct.Statistics.Accuracy
         (Battle.Struct.Statistics.get_accuracy stats)
      ),
      (get_html
         Battle.Struct.Statistics.DoubleHits
         (Battle.Struct.Statistics.get_double_hits stats)
      ),
      (get_html
         Battle.Struct.Statistics.CriticalHits
         (Battle.Struct.Statistics.get_critical_hits stats)
      )
   ]

get_all_but_gauges_signed_html : (
      Battle.Struct.Statistics.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_all_but_gauges_signed_html stats =
   [
      (get_signed_html
         Battle.Struct.Statistics.Dodges
         (Battle.Struct.Statistics.get_dodges stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.Parries
         (Battle.Struct.Statistics.get_parries stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.Accuracy
         (Battle.Struct.Statistics.get_accuracy stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.DoubleHits
         (Battle.Struct.Statistics.get_double_hits stats)
      ),
      (get_signed_html
         Battle.Struct.Statistics.CriticalHits
         (Battle.Struct.Statistics.get_critical_hits stats)
      )
   ]
