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

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
import Struct.Attributes
import Struct.Character
import Struct.Event
import Struct.GlyphBoard
import Struct.Omnimods
import Struct.Statistics
import Struct.UI
import Struct.Weapon
import Struct.WeaponSet

import View.Character
import View.Gauge

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_name : (
      Struct.Character.Type ->
      Bool ->
      (Html.Html Struct.Event.Type)
   )
get_name char can_edit =
   if can_edit
   then
      (Html.input
         [
            (Html.Attributes.class "info-card-name"),
            (Html.Attributes.class "info-card-text-field"),
            (Html.Attributes.class "character-card-name"),
            (Html.Events.onInput Struct.Event.SetCharacterName),
            (Html.Attributes.value (Struct.Character.get_name char))
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
            (Html.text (Struct.Character.get_name char))
         ]
      )

get_health_bar : (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_health_bar char =
   let
      max =
         (Struct.Statistics.get_max_health
            (Struct.Character.get_statistics char)
         )
   in
      (View.Gauge.get_html
         ("HP: " ++ (String.fromInt max))
         100.0
         [(Html.Attributes.class "character-card-health")]
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

get_movement_bar : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_movement_bar char =
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
            (String.fromInt
               (Struct.Statistics.get_movement_points
                  (Struct.Character.get_statistics char)
               )
            )
         )
         100.0
         [(Html.Attributes.class "character-card-movement")]
         []
         []
      )

get_weapon_field_header : (
      Float ->
      Struct.Weapon.Type ->
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
               (Html.text (Struct.Weapon.get_name weapon))
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
                           (toFloat (Struct.Weapon.get_damage_sum weapon))
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
                        (Struct.Weapon.get_defense_range weapon)
                     )
                     ++ "-"
                     ++
                     (String.fromInt
                        (Struct.Weapon.get_attack_range weapon)
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

get_multiplied_mod_html : Float -> (String, Int) -> (Html.Html Struct.Event.Type)
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
      Struct.Omnimods.Type ->
      Float ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_details omnimods damage_multiplier weapon =
   (Html.div
      [
         (Html.Attributes.class "character-card-weapon"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick (Struct.Event.ClickedOnWeapon True))
     ]
      [
         (get_weapon_field_header damage_multiplier weapon),
         (Html.div
            [
               (Html.Attributes.class "info-card-omnimods-listing")
            ]
            (List.map
               (get_multiplied_mod_html damage_multiplier)
               (Struct.Omnimods.get_attack_mods omnimods)
            )
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
         (Html.Attributes.class "character-card-weapon-summary"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick (Struct.Event.ClickedOnWeapon False))
      ]
      [
         (get_weapon_field_header damage_multiplier weapon)
      ]
   )

get_armor_details : (
      Struct.Omnimods.Type ->
      Struct.Armor.Type ->
      (Html.Html Struct.Event.Type)
   )
get_armor_details omnimods armor =
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
               (Html.text (Struct.Armor.get_name armor))
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "info-card-omnimods-listing")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_defense_mods omnimods)
            )
         )
      ]
   )

get_glyph_board_details : (
      Struct.GlyphBoard.Type ->
      (Html.Html Struct.Event.Type)
   )
get_glyph_board_details board =
   (Html.div
      [
         (Html.Attributes.class "character-card-glyph-board"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.TabSelected Struct.UI.GlyphBoardSelectionTab)
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "character-card-glyph-board-name")
            ]
            [
               (Html.text (Struct.GlyphBoard.get_name board))
            ]
         )
      ]
   )

stat_name  : String -> (Html.Html Struct.Event.Type)
stat_name name =
   (Html.div
      [
         (Html.Attributes.class "omnimod-icon"),
         (Html.Attributes.class ("omnimod-icon-" ++ name))
      ]
      [
      ]
   )

stat_val : Int -> Bool -> (Html.Html Struct.Event.Type)
stat_val val perc =
   (Html.div
      [
         (Html.Attributes.class "character-card-stat-val")
      ]
      [
         (Html.text
            (
               (String.fromInt val)
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
         (Html.Attributes.class "character-card-stats"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.TabSelected Struct.UI.GlyphManagementTab)
         )
      ]
      [
         (stat_name "dodg"),
         (stat_val (Struct.Statistics.get_dodges stats) True),
         (stat_name "pary"),
         (stat_val (Struct.Statistics.get_parries stats) True),
         (stat_name "accu"),
         (stat_val (Struct.Statistics.get_accuracy stats) False),
         (stat_name "dhit"),
         (stat_val (Struct.Statistics.get_double_hits stats) True),
         (stat_name "crit"),
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
         (Html.Attributes.class "character-card-stats"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.TabSelected Struct.UI.GlyphManagementTab)
         )
      ]
      [
         (stat_name "con"),
         (stat_val (Struct.Attributes.get_constitution atts) False),
         (stat_name "str"),
         (stat_val (Struct.Attributes.get_strength atts) False),
         (stat_name "dex"),
         (stat_val (Struct.Attributes.get_dexterity atts) False),
         (stat_name "spe"),
         (stat_val (Struct.Attributes.get_speed atts) False),
         (stat_name "int"),
         (stat_val (Struct.Attributes.get_intelligence atts) False),
         (stat_name "min"),
         (stat_val (Struct.Attributes.get_mind atts) False)
      ]
   )


--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_minimal_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_minimal_html char =
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
         (get_name char False),
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
                     (View.Character.get_portrait_html char True)
                  ]
               ),
               (get_health_bar char),
               (get_movement_bar char),
               (get_statuses char)
            ]
         )
      ]
   )

get_full_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_full_html char =
   let
      weapon_set = (Struct.Character.get_weapons char)
      main_weapon = (Struct.WeaponSet.get_active_weapon weapon_set)
      char_statistics = (Struct.Character.get_statistics char)
      damage_modifier = (Struct.Statistics.get_damage_modifier char_statistics)
      secondary_weapon = (Struct.WeaponSet.get_secondary_weapon weapon_set)
      armor = (Struct.Character.get_armor char)
      omnimods = (Struct.Character.get_current_omnimods char)
   in
      (Html.div
         [
            (Html.Attributes.class "info-card"),
            (Html.Attributes.class "character-card")
         ]
         [
            (get_name char True),
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
                        (View.Character.get_portrait_html char False)
                     ]
                  ),
                  (get_health_bar char),
                  (get_movement_bar char),
                  (get_statuses char)
               ]
            ),
            (get_weapon_details omnimods damage_modifier main_weapon),
            (get_armor_details omnimods armor),
            (get_glyph_board_details (Struct.Character.get_glyph_board char)),
            (get_relevant_stats char_statistics),
            (get_attributes (Struct.Character.get_attributes char)),
            (get_weapon_summary damage_modifier secondary_weapon)
         ]
      )
