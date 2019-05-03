module Battle.Lang.English exposing (..)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes
import Battle.Struct.Statistics

-- Local Module ----------------------------------------------------------------
import Struct.Event
import Struct.HelpRequest

--------------------------------------------------------------------------------
-- TYPES -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Nouns -----------------------------------------------------------------------
---- Attributes ----------------------------------------------------------------
constitution : String
constitution = "Constitution"

dexterity : String
dexterity = "Dexterity"

intelligence : String
intelligence = "Intelligence"

mind : String
mind = "Mind"

speed : String
speed = "Speed"

strength : String
strength = "Strength"

---- Statistics ----------------------------------------------------------------
max_health : String
max_health = "Max. Health"

movement_points : String
movement_points = "Movement Points"

dodges : String
dodges = "Dodge Chance"

parries : String
parries = "Parry Chance"

accuracy : String
accuracy = "Accuracy"

double_hits : String
double_hits = "Double Hit Chance"

critical_hits : String
critical_hits = "Critical Hit Chance"

-- Help ------------------------------------------------------------------------
---- Attributes ----------------------------------------------------------------
constitution_help : (Html.Html Struct.Event.Type)
constitution_help =
   (Html.div
      [
      ]
      [
         (Html.text "Constitution influences "),
         (get_stats_reference_html Battle.Struct.Statistics.MaxHealth),
         (Html.text " (75%), and "),
         (get_stats_reference_html Battle.Struct.Statistics.MovementPoints),
         (Html.text " (~33%).")
      ]
   )

dexterity_help : (Html.Html Struct.Event.Type)
dexterity_help =
   (Html.div
      [
      ]
      [
         (Html.text "Dexterity influences "),
         (get_stats_reference_html Battle.Struct.Statistics.Accuracy),
         (Html.text " (100%), "),
         (get_stats_reference_html Battle.Struct.Statistics.Dodges),
         (Html.text " (~33%), and "),
         (get_stats_reference_html Battle.Struct.Statistics.Parries),
         (Html.text " (25%).")
      ]
   )

intelligence_help : (Html.Html Struct.Event.Type)
intelligence_help =
   (Html.div
      [
      ]
      [
         (Html.text "Intelligence influences "),
         (get_stats_reference_html Battle.Struct.Statistics.CriticalHits),
         (Html.text " (100%), and "),
         (get_stats_reference_html Battle.Struct.Statistics.Parries),
         (Html.text " (25%).")
      ]
   )

mind_help : (Html.Html Struct.Event.Type)
mind_help =
   (Html.div
      [
      ]
      [
         (Html.text "Mind influences "),
         (get_stats_reference_html Battle.Struct.Statistics.DoubleHits),
         (Html.text " (50%), "),
         (get_stats_reference_html Battle.Struct.Statistics.Dodges),
         (Html.text " (~33%), "),
         (get_stats_reference_html Battle.Struct.Statistics.MaxHealth),
         (Html.text " (25%), and "),
         (get_stats_reference_html Battle.Struct.Statistics.MovementPoints),
         (Html.text " (~16%).")
      ]
   )

speed_help : (Html.Html Struct.Event.Type)
speed_help =
   (Html.div
      [
      ]
      [
         (Html.text "Speed influences "),
         (get_stats_reference_html Battle.Struct.Statistics.MovementPoints),
         (Html.text " (50%), "),
         (get_stats_reference_html Battle.Struct.Statistics.DoubleHits),
         (Html.text " (50%), and "),
         (get_stats_reference_html Battle.Struct.Statistics.Dodges),
         (Html.text " (~33%).")
      ]
   )

strength_help : (Html.Html Struct.Event.Type)
strength_help =
   (Html.div
      [
      ]
      [
         (Html.text "Strength influences attack damage (100%), and "),
         (get_stats_reference_html Battle.Struct.Statistics.Parries),
         (Html.text " (25%).")
      ]
   )

---- Statistics ----------------------------------------------------------------
max_health_help : (Html.Html Struct.Event.Type)
max_health_help =
   (Html.div
      [
      ]
      [
         (Html.text
            """
            Maximum Health is the maximum amount of hit points the character can
            have. It is based on
            """
         ),
         (get_atts_reference_html Battle.Struct.Attributes.Constitution),
         (Html.text " (75%), and "),
         (get_atts_reference_html Battle.Struct.Attributes.Mind),
         (Html.text " (25%).")
      ]
   )

movement_points_help : (Html.Html Struct.Event.Type)
movement_points_help =
   (Html.div
      [
      ]
      [
         (Html.text
            """
            Movement Points are an indication of how much this character can
            move every turn. They are based on
            """
         ),
         (get_atts_reference_html Battle.Struct.Attributes.Speed),
         (Html.text " (50%), "),
         (get_atts_reference_html Battle.Struct.Attributes.Constitution),
         (Html.text " (~33%), and "),
         (get_atts_reference_html Battle.Struct.Attributes.Mind),
         (Html.text " (~16%).")
      ]
   )

dodges_help : (Html.Html Struct.Event.Type)
dodges_help =
   (Html.div
      [
      ]
      [
         (Html.text
            """
            Dodge Chance is the base chance for this character to completely
            avoid an incoming attack. The actual chance is Dodge Chance minus
            the opponent's
            """
         ),
         (get_stats_reference_html Battle.Struct.Statistics.Accuracy),
         (Html.text
            """. Multiply by two to get the chance of avoiding partially (taking
            only half damage) an attack. Dodge Chance is based on
            """
         ),
         (get_atts_reference_html Battle.Struct.Attributes.Dexterity),
         (Html.text " (~33%), "),
         (get_atts_reference_html Battle.Struct.Attributes.Mind),
         (Html.text " (~33%), and "),
         (get_atts_reference_html Battle.Struct.Attributes.Speed),
         (Html.text " (~33%).")
      ]
   )

parries_help : (Html.Html Struct.Event.Type)
parries_help =
   (Html.div
      [
      ]
      [
         (Html.text
            """
            Parry Chance indicates how likely it is for this characters to void
            an incoming attack and replace it by one of their own. It is
            based on
            """
         ),
         (get_atts_reference_html Battle.Struct.Attributes.Dexterity),
         (Html.text " (25%), "),
         (get_atts_reference_html Battle.Struct.Attributes.Intelligence),
         (Html.text " (25%), "),
         (get_atts_reference_html Battle.Struct.Attributes.Speed),
         (Html.text " (25%), and "),
         (get_atts_reference_html Battle.Struct.Attributes.Strength),
         (Html.text " (25%).")
      ]
   )

accuracy_help : (Html.Html Struct.Event.Type)
accuracy_help =
   (Html.div
      [
      ]
      [
         (Html.text
            """
            Accuracy lower the target's chance to evade an incoming blow, as it
            is subtracted to their
            an incoming attack and replace it by one of their own. It is
            based on their
            """
         ),
         (get_stats_reference_html Battle.Struct.Statistics.Dodges),
         (Html.text ". Accuracy is based on "),
         (get_atts_reference_html Battle.Struct.Attributes.Dexterity),
         (Html.text " (100%).")
      ]
   )

double_hits_help : (Html.Html Struct.Event.Type)
double_hits_help =
   (Html.div
      [
      ]
      [
         (Html.text
            """
            Double Hit Chance indicate how likely this character is to perform
            a follow-up attack (which takes place after their target's
            retaliation, if there is any). It is based on
            """
         ),
         (get_atts_reference_html Battle.Struct.Attributes.Mind),
         (Html.text " (50%), and "),
         (get_atts_reference_html Battle.Struct.Attributes.Speed),
         (Html.text " (50%).")
      ]
   )

critical_hits_help : (Html.Html Struct.Event.Type)
critical_hits_help =
   (Html.div
      [
      ]
      [
         (Html.text
            """
            Critical Hit Chance indicate how likely this character is to perform
            an attack with double the damage. It is based on
            """
         ),
         (get_atts_reference_html Battle.Struct.Attributes.Intelligence),
         (Html.text " (100%).")
      ]
   )

get_stats_reference_html : (
      Battle.Struct.Statistics.Category ->
      (Html.Html Struct.Event.Type)
   )
get_stats_reference_html cat =
   (Html.div
      [
         (Html.Attributes.class "tooltip-reference"),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Statistic cat)
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
                     ++ (Battle.Struct.Statistics.encode_category cat)
                  )
               )
            ]
            [
            ]
         ),
         (Html.text (get_statistic_name cat))
      ]
   )

get_atts_reference_html : (
      Battle.Struct.Attributes.Category ->
      (Html.Html Struct.Event.Type)
   )
get_atts_reference_html cat =
   (Html.div
      [
         (Html.Attributes.class "tooltip-reference"),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Attribute cat)
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
                     ++ (Battle.Struct.Attributes.encode_category cat)
                  )
               )
            ]
            [
            ]
         ),
         (Html.text (get_attribute_name cat))
      ]
   )

get_attribute_name : Battle.Struct.Attributes.Category -> String
get_attribute_name cat =
   case cat of
      Battle.Struct.Attributes.Constitution -> (constitution)
      Battle.Struct.Attributes.Dexterity -> (dexterity)
      Battle.Struct.Attributes.Intelligence -> (intelligence)
      Battle.Struct.Attributes.Mind -> (mind)
      Battle.Struct.Attributes.Speed -> (speed)
      Battle.Struct.Attributes.Strength -> (strength)

get_statistic_name : Battle.Struct.Statistics.Category -> String
get_statistic_name cat =
   case cat of
      Battle.Struct.Statistics.MaxHealth -> (max_health)
      Battle.Struct.Statistics.MovementPoints -> (movement_points)
      Battle.Struct.Statistics.Dodges -> (dodges)
      Battle.Struct.Statistics.Parries -> (parries)
      Battle.Struct.Statistics.Accuracy -> (accuracy)
      Battle.Struct.Statistics.DoubleHits -> (double_hits)
      Battle.Struct.Statistics.CriticalHits -> (critical_hits)

get_attribute_category_help : (
      Battle.Struct.Attributes.Category ->
      (String, (Html.Html Struct.Event.Type))
   )
get_attribute_category_help cat =
   case cat of
      Battle.Struct.Attributes.Constitution ->
         ((constitution), (constitution_help))

      Battle.Struct.Attributes.Dexterity ->
         ((dexterity), (dexterity_help))

      Battle.Struct.Attributes.Intelligence ->
         ((intelligence), (intelligence_help))

      Battle.Struct.Attributes.Mind ->
         ((mind), (mind_help))

      Battle.Struct.Attributes.Speed ->
         ((speed), (speed_help))

      Battle.Struct.Attributes.Strength ->
         ((strength), (strength_help))

get_statistic_category_help : (
      Battle.Struct.Statistics.Category ->
      (String, (Html.Html Struct.Event.Type))
   )
get_statistic_category_help cat =
   case cat of
      Battle.Struct.Statistics.MaxHealth ->
         ((max_health), (max_health_help))

      Battle.Struct.Statistics.MovementPoints ->
         ((movement_points), (movement_points_help))

      Battle.Struct.Statistics.Dodges ->
         ((dodges), (dodges_help))

      Battle.Struct.Statistics.Parries ->
         ((parries), (parries_help))

      Battle.Struct.Statistics.Accuracy ->
         ((accuracy), (accuracy_help))

      Battle.Struct.Statistics.DoubleHits ->
         ((double_hits), (double_hits_help))

      Battle.Struct.Statistics.CriticalHits ->
         ((critical_hits), (critical_hits_help))
