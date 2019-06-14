module View.CharacterCard exposing
   (
      get_minimal_html,
      get_full_html
   )

-- Elm -------------------------------------------------------------------------
import List

import Html
import Html.Attributes
import Html.Events

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods
import Battle.Struct.Statistics

import Battle.View.Omnimods
import Battle.View.Statistic

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Weapon
import BattleCharacters.Struct.GlyphBoard

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.HelpRequest
import Struct.UI

import View.Character
import View.Gauge

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_name : (
      BattleCharacters.Struct.Character.Type ->
      Bool ->
      (Html.Html Struct.Event.Type)
   )
get_name base_char can_edit =
   if can_edit
   then
      (Html.input
         [
            (Html.Attributes.class "info-card-name"),
            (Html.Attributes.class "info-card-text-field"),
            (Html.Attributes.class "character-card-name"),
            (Html.Events.onInput Struct.Event.SetCharacterName),
            (Html.Attributes.value
               (BattleCharacters.Struct.Character.get_name base_char)
            )
         ]
         [
         ]
      )
   else
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

get_health_bar : Battle.Struct.Statistics.Type -> (Html.Html Struct.Event.Type)
get_health_bar char_stats =
   (View.Gauge.get_html
      (
         "HP: "
         ++
         (String.fromInt (Battle.Struct.Statistics.get_max_health char_stats))
      )
      100.0
      [
         (Html.Attributes.class "character-card-health"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Statistic Battle.Struct.Statistics.MaxHealth)
            )
         )
      ]
      []
      []
   )

get_statuses : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_statuses char =
   (Html.div
      [
         (Html.Attributes.class "character-card-statuses")
      ]
      [
      ]
   )

get_movement_bar : (
      Battle.Struct.Statistics.Type ->
      (Html.Html Struct.Event.Type)
   )
get_movement_bar char_stats =
   (View.Gauge.get_html
      (
         "MP: "
         ++
         (String.fromInt
            (Battle.Struct.Statistics.get_movement_points char_stats)
         )
      )
      100.0
      [
         (Html.Attributes.class "character-card-movement"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Statistic
                  Battle.Struct.Statistics.MovementPoints
               )
            )
         )
      ]
      []
      []
   )

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
               (Html.div
                  [
                     (Html.Attributes.class "omnimod-icon"),
                     (Html.Attributes.class "omnimod-icon-dmg")
                  ]
                  [
                  ]
               ),
               (Html.text
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
               ),
               (Html.div
                  [
                     (Html.Attributes.class "omnimod-icon"),
                     (Html.Attributes.class "omnimod-icon-range")
                  ]
                  [
                  ]
               ),
               (Html.text
                  (
                     (String.fromInt
                        (BattleCharacters.Struct.Weapon.get_defense_range
                           weapon
                        )
                     )
                     ++ "-"
                     ++
                     (String.fromInt
                        (BattleCharacters.Struct.Weapon.get_attack_range
                           weapon
                        )
                     )
                  )
               )
            ]
         )
      ]
   )

get_mod_html : (String, Int) -> (Html.Html Struct.Event.Type)
get_mod_html mod =
   let
      (category, value) = mod
   in
      (Html.div
         [
            (Html.Attributes.class "info-card-mod")
         ]
         [
            (Html.div
               [
                  (Html.Attributes.class "omnimod-icon"),
                  (Html.Attributes.class ("omnimod-icon-" ++ category))
               ]
               [
               ]
            ),
            (Html.text (String.fromInt value))
         ]
      )

get_multiplied_mod_html : (
      Float ->
      (String, Int) ->
      (Html.Html Struct.Event.Type)
   )
get_multiplied_mod_html multiplier mod =
   let
      (category, value) = mod
   in
      (Html.div
         [
            (Html.Attributes.class "character-card-mod")
         ]
         [
            (Html.div
               [
                  (Html.Attributes.class "omnimod-icon"),
                  (Html.Attributes.class ("omnimod-icon-" ++ category))
               ]
               [
               ]
            ),
            (Html.text
               (String.fromInt (ceiling ((toFloat value) * multiplier)))
            )
         ]
      )

get_weapon_details : (
      Float ->
      BattleCharacters.Struct.Weapon.Type ->
      Bool ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_details damage_multiplier weapon is_active_wp =
   if (is_active_wp)
   then
      (Html.div
         [
            (Html.Attributes.class "character-card-weapon"),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick
               (Struct.Event.TabSelected Struct.UI.WeaponSelectionTab)
            )
        ]
         [
            (get_weapon_field_header damage_multiplier weapon),
            (Battle.View.Omnimods.get_html_with_modifier
               damage_multiplier
               (BattleCharacters.Struct.Weapon.get_omnimods weapon)
            )
         ]
      )
   else
      (Html.div
         [
            (Html.Attributes.class "character-card-weapon-summary"),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick (Struct.Event.SwitchWeapons))
         ]
         [
            (get_weapon_field_header damage_multiplier weapon)
         ]
      )

get_armor_details : (
      Float ->
      BattleCharacters.Struct.Armor.Type ->
      (Html.Html Struct.Event.Type)
   )
get_armor_details damage_multiplier armor =
   (Html.div
      [
         (Html.Attributes.class "character-card-armor"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.TabSelected Struct.UI.ArmorSelectionTab)
         )
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
         (Battle.View.Omnimods.get_html_with_modifier
            damage_multiplier
            (BattleCharacters.Struct.Armor.get_omnimods armor)
         )
      ]
   )

get_glyph_board_details : (
      Float ->
      BattleCharacters.Struct.GlyphBoard.Type ->
      (Html.Html Struct.Event.Type)
   )
get_glyph_board_details damage_multiplier board =
   (Html.div
      [
         (Html.Attributes.class "character-card-glyph-board")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "character-card-glyph-board-name"),
               (Html.Attributes.class "clickable"),
               (Html.Events.onClick
                  (Struct.Event.TabSelected Struct.UI.GlyphBoardSelectionTab)
               )
            ]
            [
               (Html.text (BattleCharacters.Struct.GlyphBoard.get_name board))
            ]
         ),
         (Battle.View.Omnimods.get_html_with_modifier
            damage_multiplier
            (BattleCharacters.Struct.GlyphBoard.get_omnimods board)
         ),
         (Html.div
            [
               (Html.Attributes.class "clickable"),
               (Html.Events.onClick
                  (Struct.Event.TabSelected Struct.UI.GlyphManagementTab)
               )
            ]
            [
               (Html.text "[PH] Select Glyphs")
            ]
         )
      ]
   )

get_relevant_stats : (
      Battle.Struct.Statistics.Type ->
      (Html.Html Struct.Event.Type)
   )
get_relevant_stats stats =
   (Html.div
      [
         (Html.Attributes.class "character-card-stats"),
         (Html.Attributes.class "clickable")
      ]
      (Battle.View.Statistic.get_all_but_gauges_html stats)
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_minimal_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_minimal_html char =
   let
      base_char = (Struct.Character.get_base_character char)
      char_statistics =
         (BattleCharacters.Struct.Character.get_statistics base_char)
   in
      (Html.div
         [
            (Html.Attributes.class "info-card"),
            (Html.Attributes.class "info-card-minimal"),
            (Html.Attributes.class "character-card"),
            (Html.Attributes.class "character-card-minimal"),
            (Html.Events.onClick
               (Struct.Event.CharacterSelected
                  (Struct.Character.get_index char)
               )
            )
         ]
         [
            (get_name base_char False),
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
                        (View.Character.get_portrait_html True char)
                     ]
                  ),
                  (get_health_bar char_statistics),
                  (get_movement_bar char_statistics),
                  (get_statuses char)
               ]
            )
         ]
      )

get_full_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_full_html char =
   let
      base_char = (Struct.Character.get_base_character char)
      char_statistics =
         (BattleCharacters.Struct.Character.get_statistics base_char)
      damage_multiplier =
         (Battle.Struct.Statistics.get_damage_multiplier
            char_statistics
         )
      omnimods = (BattleCharacters.Struct.Character.get_omnimods base_char)
      equipment = (BattleCharacters.Struct.Character.get_equipment base_char)
      is_using_secondary =
         (BattleCharacters.Struct.Character.is_using_secondary base_char)
   in
      (Html.div
         [
            (Html.Attributes.class "info-card"),
            (Html.Attributes.class "character-card")
         ]
         [
            (get_name base_char True),
            (Html.div
               [
                  (Html.Attributes.class "info-card-top"),
                  (Html.Attributes.class "character-card-top")
               ]
               [
                  (Html.div
                     [
                        (Html.Attributes.class "info-card-picture"),
                        (Html.Attributes.class "clickable"),
                        (Html.Events.onClick
                           (Struct.Event.TabSelected
                              Struct.UI.PortraitSelectionTab
                           )
                        )
                     ]
                     [
                        (View.Character.get_portrait_html False char)
                     ]
                  ),
                  (get_health_bar char_statistics),
                  (get_movement_bar char_statistics),
                  (get_statuses char)
               ]
            ),
            (get_weapon_details
               damage_multiplier
               (BattleCharacters.Struct.Equipment.get_primary_weapon equipment)
               (not is_using_secondary)
            ),
            (get_armor_details
               damage_multiplier
               (BattleCharacters.Struct.Equipment.get_armor equipment)
            ),
            (get_glyph_board_details
               damage_multiplier
               (BattleCharacters.Struct.Equipment.get_glyph_board equipment)
            ),
            (get_relevant_stats char_statistics),
            (get_weapon_details
               damage_multiplier
               (BattleCharacters.Struct.Equipment.get_secondary_weapon
                  equipment
               )
               is_using_secondary
            )
         ]
      )
