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

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Omnimods
import Battle.Struct.Attributes

import Battle.View.Omnimods
import Battle.View.Attribute

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

get_health_bar : Battle.Struct.Attributes.Type -> (Html.Html Struct.Event.Type)
get_health_bar char_atts =
   (View.Gauge.get_html
      (
         "HP: "
         ++
         (String.fromInt (Battle.Struct.Attributes.get_max_health char_atts))
      )
      100.0
      [
         (Html.Attributes.class "character-card-health"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Attribute Battle.Struct.Attributes.MaxHealth)
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
      Battle.Struct.Attributes.Type ->
      (Html.Html Struct.Event.Type)
   )
get_movement_bar char_atts =
   (View.Gauge.get_html
      (
         "MP: "
         ++
         (String.fromInt
            (Battle.Struct.Attributes.get_movement_points char_atts)
         )
      )
      100.0
      [
         (Html.Attributes.class "character-card-movement"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.RequestedHelp
               (Struct.HelpRequest.Attribute
                  Battle.Struct.Attributes.MovementPoints
               )
            )
         )
      ]
      []
      []
   )

get_weapon_field_header : (
      Bool ->
      BattleCharacters.Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_field_header is_active_wp weapon =
   (Html.div
      [
         (Html.Attributes.class "character-card-header")
      ]
      [
         (
            if (is_active_wp)
            then
               (Html.div
                  [
                     (Html.Attributes.class "character-card-active-weapon")
                  ]
                  [
                     (Html.text "(Equipped)")
                  ]
               )
            else (Util.Html.nothing)
         ),
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
            (Html.Attributes.class "info-card-mod"),
            (Html.Attributes.class
               (
                  if (value < 0)
                  then "omnimod-negative-value"
                  else
                     if (value > 0)
                     then "omnimod-positive-value"
                     else "omnimod-nil-value"
               )
            )
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

get_weapon_details : (
      Struct.UI.Tab ->
      Bool ->
      BattleCharacters.Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_details current_tab is_active_wp weapon =
   (Html.div
      [
         (Html.Attributes.class "character-card-weapon"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (
               if (is_active_wp)
               then (Struct.Event.TabSelected Struct.UI.WeaponSelectionTab)
               else (Struct.Event.SwitchWeapons)
            )
         )
      ]
      [
         (get_weapon_field_header is_active_wp weapon),
         (
            if (is_active_wp && (current_tab == Struct.UI.WeaponSelectionTab))
            then
               (Battle.View.Omnimods.get_html
                  (BattleCharacters.Struct.Weapon.get_omnimods weapon)
               )
            else (Util.Html.nothing)
         )
      ]
   )

get_armor_details : (
      Struct.UI.Tab ->
      BattleCharacters.Struct.Armor.Type ->
      (Html.Html Struct.Event.Type)
   )
get_armor_details current_tab armor =
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
         (
            if (current_tab == Struct.UI.ArmorSelectionTab)
            then
               (Battle.View.Omnimods.get_html
                  (BattleCharacters.Struct.Armor.get_omnimods armor)
               )
            else (Util.Html.nothing)
         )
      ]
   )

get_glyph_board_details : (
      BattleCharacters.Struct.GlyphBoard.Type ->
      (Html.Html Struct.Event.Type)
   )
get_glyph_board_details board =
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

get_relevant_atts : (
      Battle.Struct.Omnimods.Type ->
      Battle.Struct.Attributes.Type ->
      (Html.Html Struct.Event.Type)
   )
get_relevant_atts omnimods atts =
   (Html.div
      [
         (Html.Attributes.class "character-card-atts"),
         (Html.Attributes.class "roster-editor-atts")
      ]
      (
         [
            (
               let
                  damage_multiplier =
                     (Battle.Struct.Attributes.get_damage_multiplier atts)
               in
                  (Html.div
                     [
                        (Html.Attributes.class "omnimod-attack-mods")
                     ]
                     (List.map
                        (
                           \(s, i) ->
                           (get_mod_html
                              (
                                 s,
                                 (ceiling ((toFloat i) * damage_multiplier))
                              )
                           )
                        )
                        (Battle.Struct.Omnimods.get_attack_mods omnimods)
                     )
                  )
            ),
            (Html.div
               [
                  (Html.Attributes.class "omnimod-defense-mods")
               ]
               (List.map
                  (get_mod_html)
                  (Battle.Struct.Omnimods.get_defense_mods omnimods)
               )
            )
         ]
         ++ (Battle.View.Attribute.get_true_all_html atts)
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_minimal_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_minimal_html char =
   let
      base_char = (Struct.Character.get_base_character char)
      char_attributes =
         (BattleCharacters.Struct.Character.get_attributes base_char)
   in
      (Html.div
         [
            (Html.Attributes.class "info-card"),
            (Html.Attributes.class "info-card-minimal"),
            (Html.Attributes.class "character-card"),
            (Html.Attributes.class "character-card-minimal"),
            (Html.Attributes.class
               (
                  if (Struct.Character.get_is_valid char)
                  then "roster-editor-valid-character"
                  else "roster-editor-invalid-character"
               )
            ),
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
                  (get_health_bar char_attributes),
                  (get_movement_bar char_attributes),
                  (get_statuses char)
               ]
            )
         ]
      )

get_full_html : (
      Struct.UI.Tab ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_full_html current_tab char =
   let
      base_char = (Struct.Character.get_base_character char)
      char_attributes =
         (BattleCharacters.Struct.Character.get_attributes base_char)
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
                  (get_health_bar char_attributes),
                  (get_movement_bar char_attributes),
                  (get_statuses char)
               ]
            ),
            (get_weapon_details
               current_tab
               (not is_using_secondary)
               (BattleCharacters.Struct.Equipment.get_primary_weapon equipment)
            ),
            (get_weapon_details
               current_tab
               is_using_secondary
               (BattleCharacters.Struct.Equipment.get_secondary_weapon
                  equipment
               )
            ),
            (get_armor_details
               current_tab
               (BattleCharacters.Struct.Equipment.get_armor equipment)
            ),
            (get_glyph_board_details
               (BattleCharacters.Struct.Equipment.get_glyph_board equipment)
            ),
            (get_relevant_atts omnimods char_attributes)
         ]
      )
