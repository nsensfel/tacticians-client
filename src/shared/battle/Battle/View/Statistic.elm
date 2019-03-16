module Battle.View.Statistic exposing
   (
      get_html,
      get_all_html,
      get_signed_html,
      get_all_signed_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Statistics

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Statistic

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
      Battle.Struct.Statistic.Category ->
      Int ->
      (List (Html.Html Struct.Event.Type))
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
               (Html.Statistics.class "omnimod-icon"),
               (Html.Statistics.class
                  (
                     "omnimod-icon-"
                     ++ (Battle.Struct.Statistic.encode_category statistic)
                  )
               ),
            ]
            [
            ]
         ),
         (Html.div
            [
               (Html.Statistics.class "omnimod-value")
            ]
            [
               (Html.text ((String.FromInt value) ++ "%"))
            ]
         )
      ]
   )

get_signed_html : (
      Battle.Struct.Statistic.Category ->
      Int ->
      (Html.Html Struct.Event.Type)
   )
get_signed_html statistic value =
   (Html.div
      [
         (
            if (value < 0)
            then (Html.Statistics.class "omnimod-negative")
            else (Html.Statistics.class "omnimod-positive")
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
               (Html.Statistics.class "omnimod-icon"),
               (Html.Statistics.class
                  (
                     "omnimod-icon-"
                     ++ (Battle.Struct.Statistic.encode_category statistic)
                  )
               ),
            ]
            [
            ]
         ),
         (Html.div
            [
               (Html.Statistics.class "omnimod-value")
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
                     ++ "%"
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
