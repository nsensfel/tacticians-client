module Battle.Lang.English exposing (..)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Statistics
import Battle.Struct.DamageType

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

damage_modifier : String
damage_modifier = "Damage Multiplier"

---- Damage Types --------------------------------------------------------------
slash : String
slash = "Slashing Damage"

blunt : String
blunt = "Bludgeoning Damage"

pierce : String
pierce = "Piercing Damage"

base : String
base = "Universal Damage"

-- Help ------------------------------------------------------------------------
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
            have.
            """
         )
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
            move every turn.
            """
         )
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
            """. Multiply by two to get the chance of at least avoiding
            partially (taking only half damage) an attack.
            """
         )
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
            an incoming attack and replace it by one of their own. This requires
            a melee weapon. Attacks of Opportunity cannot be parried.
            """
         )
      ]
   )

accuracy_help : (Html.Html Struct.Event.Type)
accuracy_help =
   (Html.div
      [
      ]
      [
         (Html.text
            "Accuracy lowers the target's chance to evade an incoming blow ("
         ),
         (get_stats_reference_html Battle.Struct.Statistics.Dodges),
         (Html.text ").")
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
            retaliation, if there is any).
            """
         )
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
            an attack with double the damage.
            """
         )
      ]
   )
damage_modifier_help : (Html.Html Struct.Event.Type)
damage_modifier_help =
   (Html.div
      [
      ]
      [
         (Html.text
            """
            Increases or decreases (if lower than 100%) the damage of all of
            this character's attacks.
            """
         )
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

---- Damage Types --------------------------------------------------------------
slash_help : (Html.Html Struct.Event.Type)
slash_help =
   (Html.div
      [
      ]
      [
         (Html.text "Tis but a scratch. You had worse.")
      ]
   )

blunt_help : (Html.Html Struct.Event.Type)
blunt_help =
   (Html.div
      [
      ]
      [
         (Html.text "At least words will never harm you.")
      ]
   )

pierce_help : (Html.Html Struct.Event.Type)
pierce_help =
   (Html.div
      [
      ]
      [
         (Html.text "Improves your aerodynamics.")
      ]
   )

base_help : (Html.Html Struct.Event.Type)
base_help =
   (Html.div
      [
      ]
      [
         (Html.text
            "Defensive only. This is applied to every type of incoming damage."
         )
      ]
   )

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
      Battle.Struct.Statistics.DamageModifier -> (damage_modifier)

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

      Battle.Struct.Statistics.DamageModifier ->
         ((damage_modifier), (damage_modifier_help))

get_damage_type_help : (
      Battle.Struct.DamageType.Type ->
      (String, (Html.Html Struct.Event.Type))
   )
get_damage_type_help cat =
   case cat of
      Battle.Struct.DamageType.Base ->
         ((base), (base_help))

      Battle.Struct.DamageType.Slash ->
         ((slash), (slash_help))

      Battle.Struct.DamageType.Blunt ->
         ((blunt), (blunt_help))

      Battle.Struct.DamageType.Pierce ->
         ((pierce), (pierce_help))

      _ -> ("None Damage", (Html.div [] [(Html.text "Should not appear.")]))
