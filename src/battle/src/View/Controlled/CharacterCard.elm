module View.Controlled.CharacterCard exposing
   (
      get_minimal_html,
      get_summary_html,
      get_full_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map -------------------------------------------------------------------
import Struct.Armor
import Struct.Attributes
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.HelpRequest
import Struct.Navigator
import Struct.Statistics
import Struct.Weapon
import Struct.WeaponSet

import Util.Html

import View.Character
import View.Gauge

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_name : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_name char =
   (Html.div
      [
         (Html.Attributes.class "battle-info-card-name"),
         (Html.Attributes.class "battle-info-card-text-field"),
         (Html.Attributes.class "battle-character-card-name")
      ]
      [
         (Html.text (Struct.Character.get_name char))
      ]
   )

get_health_bar : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_health_bar char =
   let
      current = (Struct.Character.get_sane_current_health char)
      max =
         (Struct.Statistics.get_max_health
            (Struct.Character.get_statistics char)
         )
   in
      (View.Gauge.get_html
         ("HP: " ++ (toString current) ++ "/" ++ (toString max))
         (100.0 * ((toFloat current)/(toFloat max)))
         [(Html.Attributes.class "battle-character-card-health")]
         []
         []
      )

get_rank_status : (
      Struct.Character.Rank ->
      (Html.Html Struct.Event.Type)
   )
get_rank_status rank =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-status"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp (Struct.HelpRequest.HelpOnRank rank))
         ),
         (Html.Attributes.class
            (
               case rank of
                  Struct.Character.Commander ->
                     "battle-character-card-commander-status"

                  Struct.Character.Target ->
                     "battle-character-card-target-status"

                  Struct.Character.Optional -> ""
            )
         )
      ]
      [
      ]
   )

get_statuses : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_statuses char =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-statuses")
      ]
      [
         (
            case (Struct.Character.get_rank char) of
               Struct.Character.Optional -> (Util.Html.nothing)
               other -> (get_rank_status other)
         )
      ]
   )

get_active_movement_bar : (
      (Maybe Struct.Navigator.Type) ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_active_movement_bar maybe_navigator char =
   let
      max =
         (Struct.Statistics.get_movement_points
            (Struct.Character.get_statistics char)
         )
      current =
         case maybe_navigator of
            (Just navigator) ->
               (Struct.Navigator.get_remaining_points navigator)

            Nothing ->
               max
   in
      (View.Gauge.get_html
         ("MP: " ++ (toString current) ++ "/" ++ (toString max))
         (100.0 * ((toFloat current)/(toFloat max)))
         [(Html.Attributes.class "battle-character-card-movement")]
         []
         []
      )

get_inactive_movement_bar : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_inactive_movement_bar char =
   let
      max =
         (Struct.Statistics.get_movement_points
            (Struct.Character.get_statistics char)
         )
   in
      (View.Gauge.get_html
         (
            "MP: "
            ++
            (toString
               (Struct.Statistics.get_movement_points
                  (Struct.Character.get_statistics char)
               )
            )
         )
         100.0
         [(Html.Attributes.class "battle-character-card-movement")]
         []
         []
      )

get_movement_bar : (
      Struct.CharacterTurn.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_movement_bar char_turn char =
   case (Struct.CharacterTurn.try_getting_active_character char_turn) of
      (Just active_char) ->
         if
         (
            (Struct.Character.get_index active_char)
            ==
            (Struct.Character.get_index char)
         )
         then
            (get_active_movement_bar
               (Struct.CharacterTurn.try_getting_navigator char_turn)
               active_char
            )
         else
            (get_inactive_movement_bar char)

      Nothing ->
         (get_inactive_movement_bar char)

get_weapon_details : (
      Float ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_details damage_multiplier weapon =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-weapon")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "battle-character-card-weapon-name")
            ]
            [
               (Html.text (Struct.Weapon.get_name weapon))
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "battle-character-card-weapon-name")
            ]
            [
               (Html.text
                  (
                     -- TODO [VISUAL][HIGH]: unimplemented
                     "[PH] WEAPON RANGE AND CHAR (ATK MODS * "
                     ++ (toString damage_multiplier)
                     ++ ")"
                  )
               )
            ]
         )
      ]
   )

get_weapon_summary : (
      Float ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_summary damage_multiplier weapon =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-weapon-summary")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "battle-character-card-weapon-name")
            ]
            [
               (Html.text (Struct.Weapon.get_name weapon))
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "battle-character-card-weapon-name")
            ]
            [
               (Html.text
                  (
                     -- TODO [VISUAL][HIGH]: unimplemented
                     "[PH] WEAPON (ATK_SUM * "
                     ++ (toString damage_multiplier)
                     ++ ") AND RANGES"
                  )
               )
            ]
         )
      ]
   )

get_armor_details : (
      Struct.Armor.Type ->
      (Html.Html Struct.Event.Type)
   )
get_armor_details armor =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-armor")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "battle-character-card-armor-name")
            ]
            [
               (Html.text (Struct.Armor.get_name armor))
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "battle-character-card-armor-stats")
            ]
            [
               (Html.text "[PH] CHAR DEF MODS")
            ]
         )
      ]
   )

stat_name  : String -> (Html.Html Struct.Event.Type)
stat_name name =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-stat-name")
      ]
      [
         (Html.text name)
      ]
   )

stat_val : Int -> Bool -> (Html.Html Struct.Event.Type)
stat_val val perc =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-stat-val")
      ]
      [
         (Html.text
            (
               (toString val)
               ++
               (
                  if perc
                  then
                     "%"
                  else
                     ""
               )
            )
         )
      ]
   )

get_relevant_stats : (
      Struct.Statistics.Type ->
      (Html.Html Struct.Event.Type)
   )
get_relevant_stats stats =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-stats")
      ]
      [
         (stat_name "Dodge"),
         (stat_val (Struct.Statistics.get_dodges stats) True),
         (stat_name "Parry"),
         (stat_val (Struct.Statistics.get_parries stats) True),
         (stat_name "Accu."),
         (stat_val (Struct.Statistics.get_accuracy stats) False),
         (stat_name "2xHit"),
         (stat_val (Struct.Statistics.get_double_hits stats) True),
         (stat_name "Crit."),
         (stat_val (Struct.Statistics.get_critical_hits stats) True)
      ]
   )

get_attributes : (
      Struct.Attributes.Type ->
      (Html.Html Struct.Event.Type)
   )
get_attributes atts =
   (Html.div
      [
         (Html.Attributes.class "battle-character-card-stats")
      ]
      [
         (stat_name "Con"),
         (stat_val (Struct.Attributes.get_constitution atts) False),
         (stat_name "Dex"),
         (stat_val (Struct.Attributes.get_dexterity atts) False),
         (stat_name "Int"),
         (stat_val (Struct.Attributes.get_intelligence atts) False),
         (stat_name "Min"),
         (stat_val (Struct.Attributes.get_mind atts) False),
         (stat_name "Spe"),
         (stat_val (Struct.Attributes.get_speed atts) False),
         (stat_name "Str"),
         (stat_val (Struct.Attributes.get_strength atts) False)
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_minimal_html : (
      Int ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_minimal_html player_ix char =
   (Html.div
      [
         (Html.Attributes.class "battle-info-card"),
         (Html.Attributes.class "battle-info-card-minimal"),
         (Html.Attributes.class "battle-character-card"),
         (Html.Attributes.class "battle-character-card-minimal")
      ]
      [
         (get_name char),
         (Html.div
            [
               (Html.Attributes.class "battle-info-card-top"),
               (Html.Attributes.class "battle-character-card-top")
            ]
            [
               (Html.div
                  [
                     (Html.Attributes.class "battle-info-card-picture")
                  ]
                  [
                     (View.Character.get_portrait_html player_ix char)
                  ]
               ),
               (get_health_bar char),
               (get_inactive_movement_bar char),
               (get_statuses char)
            ]
         )
      ]
   )

get_summary_html : (
      Struct.CharacterTurn.Type ->
      Int ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_summary_html char_turn player_ix char =
   let
      weapon_set = (Struct.Character.get_weapons char)
      main_weapon = (Struct.WeaponSet.get_active_weapon weapon_set)
      char_statistics = (Struct.Character.get_statistics char)
      char_attributes =  (Struct.Character.get_attributes char)
      damage_modifier = (Struct.Statistics.get_damage_modifier char_statistics)
      secondary_weapon = (Struct.WeaponSet.get_secondary_weapon weapon_set)
   in
      (Html.div
         [
            (Html.Attributes.class "battle-character-card")
         ]
         [
            (get_name char),
            (Html.div
               [
                  (Html.Attributes.class "battle-info-card-top"),
                  (Html.Attributes.class "battle-character-card-top")
               ]
               [
                  (Html.div
                     [
                        (Html.Attributes.class "battle-info-card-picture")
                     ]
                     [
                        (View.Character.get_portrait_html player_ix char)
                     ]
                  ),
                  (get_health_bar char),
                  (get_movement_bar char_turn char),
                  (get_statuses char)
               ]
            ),
            (get_weapon_details damage_modifier main_weapon),
            (get_armor_details (Struct.Character.get_armor char)),
            (get_relevant_stats char_statistics),
            (get_weapon_summary damage_modifier secondary_weapon)
         ]
      )

get_full_html : (
      Int ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_full_html player_ix char =
   let
      weapon_set = (Struct.Character.get_weapons char)
      main_weapon = (Struct.WeaponSet.get_active_weapon weapon_set)
      char_statistics = (Struct.Character.get_statistics char)
      char_attributes =  (Struct.Character.get_attributes char)
      damage_modifier = (Struct.Statistics.get_damage_modifier char_statistics)
      secondary_weapon = (Struct.WeaponSet.get_secondary_weapon weapon_set)
      armor = (Struct.Character.get_armor char)
   in
      (Html.div
         [
            (Html.Attributes.class "battle-info-card"),
            (Html.Attributes.class "battle-character-card")
         ]
         [
            (get_name char),
            (Html.div
               [
                  (Html.Attributes.class "battle-info-card-top"),
                  (Html.Attributes.class "battle-character-card-top")
               ]
               [
                  (Html.div
                     [
                        (Html.Attributes.class "battle-info-card-picture")
                     ]
                     [
                        (View.Character.get_portrait_html player_ix char)
                     ]
                  ),
                  (get_health_bar char),
                  (get_inactive_movement_bar char),
                  (get_statuses char)
               ]
            ),
            (get_weapon_details damage_modifier main_weapon),
            (get_armor_details armor),
            (get_relevant_stats char_statistics),
            (get_weapon_summary damage_modifier secondary_weapon),
            (get_attributes char_attributes)
         ]
      )
