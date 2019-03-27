module View.Controlled.CharacterCard exposing
   (
      get_minimal_html,
      get_summary_html,
      get_full_html
   )

-- Elm -------------------------------------------------------------------------
import List

import Html
import Html.Attributes
import Html.Events

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Battle ----------------------------------------------------------------------
import Battle.Struct.DamageType
import Battle.Struct.Omnimods
import Battle.Struct.Statistics

import Battle.View.Gauge
import Battle.View.Statistic
import Battle.View.DamageType

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Weapon

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.HelpRequest
import Struct.Navigator

import View.Character

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_name : (
      BattleCharacters.Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_name base_char =
   (Html.div
      [
         (Html.Attributes.class "info-card-name"),
         (Html.Attributes.class "info-card-text-field"),
         (Html.Attributes.class "character-card-name")
      ]
      [
         (Html.text (BattleCharacters.Struct.Character.get_name base_char))
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
         (Battle.Struct.Statistics.get_max_health
            (BattleCharacters.Struct.Character.get_statistics
               (Struct.Character.get_base_character char)
            )
         )
   in
      (Battle.View.Gauge.get_html
         ("HP: " ++ (String.fromInt current) ++ "/" ++ (String.fromInt max))
         (100.0 * ((toFloat current)/(toFloat max)))
         [(Html.Attributes.class "character-card-health")]
         []
         []
      )

get_rank_status : Struct.Character.Rank -> (Html.Html Struct.Event.Type)
get_rank_status rank =
   (Html.div
      [
         (Html.Attributes.class "character-card-status"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp (Struct.HelpRequest.Rank rank))
         ),
         (Html.Attributes.class
            (
               case rank of
                  Struct.Character.Commander ->
                     "character-card-commander-status"

                  Struct.Character.Target ->
                     "character-card-target-status"

                  Struct.Character.Optional -> ""
            )
         )
      ]
      [
      ]
   )

get_statuses : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_statuses char =
   (Html.div
      [
         (Html.Attributes.class "character-card-statuses")
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
         (Battle.Struct.Statistics.get_movement_points
            (BattleCharacters.Struct.Character.get_statistics
               (Struct.Character.get_base_character char)
            )
         )
      current =
         case maybe_navigator of
            (Just navigator) ->
               (Struct.Navigator.get_remaining_points navigator)

            Nothing ->
               max
   in
      (Battle.View.Gauge.get_html
         ("MP: " ++ (String.fromInt current) ++ "/" ++ (String.fromInt max))
         (100.0 * ((toFloat current)/(toFloat max)))
         [(Html.Attributes.class "character-card-movement")]
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
         (Battle.Struct.Statistics.get_movement_points
            (BattleCharacters.Struct.Character.get_statistics
               (Struct.Character.get_base_character char)
            )
         )
   in
      (Battle.View.Gauge.get_html
         ( "MP: " ++ (String.fromInt max))
         100.0
         [(Html.Attributes.class "character-card-movement")]
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

get_weapon_field_header : (
      Float ->
      BattleCharacters.Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_field_header damage_multiplier weapon =
   (Html.div
      [
         (Html.Attributes.class "character-card-header")
      ]
      [
         (Html.div
            [
            ]
            [
               (Html.text (BattleCharacters.Struct.Weapon.get_name weapon))
            ]
         ),
         (Html.div
            [
            ]
            [
               (Html.text
                  (
                     "~"
                     ++
                     (String.fromInt
                        (ceiling
                           (
                              (toFloat
                                 (BattleCharacters.Struct.Weapon.get_damage_sum
                                    weapon
                                 )
                              )
                              * damage_multiplier
                           )
                        )
                     )
                     ++ " dmg @ ["
                     ++
                     (String.fromInt
                        (BattleCharacters.Struct.Weapon.get_defense_range
                           weapon
                        )
                     )
                     ++ ", "
                     ++
                     (String.fromInt
                        (BattleCharacters.Struct.Weapon.get_attack_range
                           weapon
                        )
                     )
                     ++ "]"
                  )
               )
            ]
         )
      ]
   )

get_weapon_details : (
      Battle.Struct.Omnimods.Type ->
      Float ->
      BattleCharacters.Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_details omnimods damage_multiplier weapon =
   (Html.div
      [
         (Html.Attributes.class "character-card-weapon")
      ]
      [
         (get_weapon_field_header damage_multiplier weapon),
         (Html.div
            [
               (Html.Attributes.class "omnimod-attack-mods")
            ]
            (List.map
               (\(k, v) ->
                  (Battle.View.DamageType.get_html
                     (Battle.Struct.DamageType.decode k)
                     (ceiling ((toFloat v) * damage_multiplier))
                  )
               )
               (Battle.Struct.Omnimods.get_attack_mods omnimods)
            )
         )
      ]
   )

get_weapon_summary : (
      Float ->
      BattleCharacters.Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_summary damage_multiplier weapon =
   (Html.div
      [
         (Html.Attributes.class "character-card-weapon-summary")
      ]
      [
         (get_weapon_field_header damage_multiplier weapon)
      ]
   )

get_armor_details : (
      Battle.Struct.Omnimods.Type ->
      BattleCharacters.Struct.Armor.Type ->
      (Html.Html Struct.Event.Type)
   )
get_armor_details omnimods armor =
   (Html.div
      [
         (Html.Attributes.class "character-card-armor")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "character-card-armor-name")
            ]
            [
               (Html.text (BattleCharacters.Struct.Armor.get_name armor))
            ]
         ),
         (Html.div
            []
            (List.map
               (\(k, v) ->
                  (Battle.View.DamageType.get_html
                     (Battle.Struct.DamageType.decode k)
                     v
                  )
               )
               (Battle.Struct.Omnimods.get_defense_mods omnimods)
            )
         )
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
   let base_char = (Struct.Character.get_base_character char) in
   (Html.div
      [
         (Html.Attributes.class "info-card"),
         (Html.Attributes.class "info-card-minimal"),
         (Html.Attributes.class "character-card"),
         (Html.Attributes.class "character-card-minimal")
      ]
      [
         (get_name base_char),
         (Html.div
            [
               (Html.Attributes.class "info-card-top"),
               (Html.Attributes.class "character-card-top")
            ]
            [
               (Html.div
                  [
                     (Html.Attributes.class "info-card-picture")
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
      base_char = (Struct.Character.get_base_character char)
      char_statistics =
         (BattleCharacters.Struct.Character.get_statistics base_char)
      damage_modifier =
         (Battle.Struct.Statistics.get_damage_modifier
            char_statistics
         )
      omnimods = (BattleCharacters.Struct.Character.get_omnimods base_char)
      equipment = (BattleCharacters.Struct.Character.get_equipment base_char)
   in
      (Html.div
         [
            (Html.Attributes.class "character-card")
         ]
         [
            (get_name base_char),
            (Html.div
               [
                  (Html.Attributes.class "info-card-top"),
                  (Html.Attributes.class "character-card-top")
               ]
               [
                  (Html.div
                     [
                        (Html.Attributes.class "info-card-picture")
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
            (get_weapon_details
               omnimods
               damage_modifier
               (BattleCharacters.Struct.Character.get_active_weapon
                  base_char
               )
            ),
            (get_armor_details
               omnimods
               (BattleCharacters.Struct.Equipment.get_armor equipment)
            ),
            (Html.div
               []
               (Battle.View.Statistic.get_all_but_gauges_html
                  char_statistics
               )
            ),
            (get_weapon_summary
               damage_modifier
               (BattleCharacters.Struct.Character.get_inactive_weapon
                  base_char
               )
            )
         ]
      )

get_full_html : (
      Int ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_full_html player_ix char =
   let
      base_char = (Struct.Character.get_base_character char)
      char_statistics =
         (BattleCharacters.Struct.Character.get_statistics base_char)
      damage_modifier =
         (Battle.Struct.Statistics.get_damage_modifier
            char_statistics
         )
      omnimods = (BattleCharacters.Struct.Character.get_omnimods base_char)
      equipment = (BattleCharacters.Struct.Character.get_equipment base_char)
   in
      (Html.div
         [
            (Html.Attributes.class "info-card"),
            (Html.Attributes.class "character-card")
         ]
         [
            (get_name base_char),
            (Html.div
               [
                  (Html.Attributes.class "info-card-top"),
                  (Html.Attributes.class "character-card-top")
               ]
               [
                  (Html.div
                     [
                        (Html.Attributes.class "info-card-picture")
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
            (get_weapon_details
               omnimods
               damage_modifier
               (BattleCharacters.Struct.Character.get_active_weapon
                  base_char
               )
            ),
            (get_armor_details
               omnimods
               (BattleCharacters.Struct.Equipment.get_armor equipment)
            ),
            (Html.div
               []
               (Battle.View.Statistic.get_all_but_gauges_html
                  char_statistics
               )
            ),
            (get_weapon_summary
               damage_modifier
               (BattleCharacters.Struct.Character.get_inactive_weapon
                  base_char
               )
            )
         ]
      )
