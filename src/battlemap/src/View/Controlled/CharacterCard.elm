module View.Controlled.CharacterCard exposing
   (
      get_minimal_html,
      get_summary_html,
      get_full_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Armor
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.Statistics
import Struct.Weapon
import Struct.WeaponSet

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
         (Html.Attributes.class "battlemap-character-card-name")
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
      current = (Struct.Character.get_current_health char)
      max =
         (Struct.Statistics.get_max_health
            (Struct.Character.get_statistics char)
         )
   in
      (View.Gauge.get_html
         ("HP: " ++ (toString current) ++ "/" ++ (toString max))
         (100.0 * ((toFloat current)/(toFloat max)))
         [(Html.Attributes.class "battlemap-character-card-health")]
         []
         []
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
         [(Html.Attributes.class "battlemap-character-card-movement")]
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
         [(Html.Attributes.class "battlemap-character-card-movement")]
         []
         []
      )

get_movement_bar : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_movement_bar model char =
   case (Struct.CharacterTurn.try_getting_active_character model.char_turn) of
      (Just active_char) ->
         if
         (
            (Struct.Character.get_ref active_char)
            ==
            (Struct.Character.get_ref char)
         )
         then
            (get_active_movement_bar
               (Struct.CharacterTurn.try_getting_navigator model.char_turn)
               active_char
            )
         else
            (get_inactive_movement_bar char)

      Nothing ->
         (get_inactive_movement_bar char)

get_weapon_details : (
      Struct.Statistics.Type ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_details stats weapon =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-weapon")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "battlemap-character-card-weapon-name")
            ]
            [
               (Html.text (Struct.Weapon.get_name weapon))
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "battlemap-character-card-weapon-name")
            ]
            [
               (Html.text
                  (
                     "["
                     ++ (toString (Struct.Statistics.get_damage_min stats))
                     ++ ", "
                     ++ (toString (Struct.Statistics.get_damage_max stats))
                     ++ "] "
                     ++
                     (case (Struct.Weapon.get_damage_type weapon) of
                        Struct.Weapon.Slash -> "slashing "
                        Struct.Weapon.Pierce -> "piercing "
                        Struct.Weapon.Blunt -> "bludgeoning "
                     )
                     ++
                     (case (Struct.Weapon.get_range_type weapon) of
                        Struct.Weapon.Ranged -> "ranged"
                        Struct.Weapon.Melee -> "melee"
                     )
                  )
               )
            ]
         )
      ]
   )

get_weapon_summary : (
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_summary weapon =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-weapon-summary")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "battlemap-character-card-weapon-name")
            ]
            [
               (Html.text (Struct.Weapon.get_name weapon))
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "battlemap-character-card-weapon-name")
            ]
            [
               (Html.text
                  (
                     (case (Struct.Weapon.get_damage_type weapon) of
                        Struct.Weapon.Slash -> "Slashing "
                        Struct.Weapon.Pierce -> "Piercing "
                        Struct.Weapon.Blunt -> "Bludgeoning "
                     )
                     ++
                     (case (Struct.Weapon.get_range_type weapon) of
                        Struct.Weapon.Ranged -> "ranged"
                        Struct.Weapon.Melee -> "melee"
                     )
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
         (Html.Attributes.class "battlemap-character-card-armor")
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "battlemap-character-card-armor-name")
            ]
            [
               (Html.text (Struct.Armor.get_name armor))
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "battlemap-character-card-armor-stats")
            ]
            [
               (stat_name "Slash"),
               (stat_val
                  (Struct.Armor.get_resistance_to Struct.Weapon.Slash armor)
                  False
               ),
               (stat_name "Pierc."),
               (stat_val
                  (Struct.Armor.get_resistance_to Struct.Weapon.Pierce armor)
                  False
               ),
               (stat_name "Blund."),
               (stat_val
                  (Struct.Armor.get_resistance_to Struct.Weapon.Blunt armor)
                  False
               )
            ]
         )
      ]
   )

stat_name  : String -> (Html.Html Struct.Event.Type)
stat_name name =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-stat-name")
      ]
      [
         (Html.text name)
      ]
   )

stat_val : Int -> Bool -> (Html.Html Struct.Event.Type)
stat_val val perc =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card-stat-val")
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
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_relevant_stats model char weapon =
   let
      stats = (Struct.Character.get_statistics char)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-character-card-stats")
         ]
         [
            (stat_name "Dodge"),
            (stat_val (Struct.Statistics.get_dodges stats) True),
            (stat_name "Parry"),
            (stat_val
               (case (Struct.Weapon.get_range_type weapon) of
                  Struct.Weapon.Ranged -> 0
                  Struct.Weapon.Melee -> (Struct.Statistics.get_parries stats)
               )
               True
            ),
            (stat_name "Accu."),
            (stat_val (Struct.Statistics.get_accuracy stats) False),
            (stat_name "2xHit"),
            (stat_val (Struct.Statistics.get_double_hits stats) True),
            (stat_name "Crit."),
            (stat_val (Struct.Statistics.get_critical_hits stats) True)
         ]
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_minimal_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_minimal_html model char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card"),
         (Html.Attributes.class "battlemap-character-card-minimal")
      ]
      [
         (get_name char),
         (Html.div
            [
               (Html.Attributes.class "battlemap-character-card-top")
            ]
            [
               (View.Character.get_portrait_html model.player_id char),
               (get_health_bar char),
               (get_movement_bar model char)
            ]
         )
      ]
   )

get_summary_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_summary_html model char =
   let
      weapon_set = (Struct.Character.get_weapons char)
      main_weapon = (Struct.WeaponSet.get_active_weapon weapon_set)
      char_statistics = (Struct.Character.get_statistics char)
      secondary_weapon = (Struct.WeaponSet.get_secondary_weapon weapon_set)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-character-card")
         ]
         [
            (get_name char),
            (Html.div
               [
                  (Html.Attributes.class "battlemap-character-card-top")
               ]
               [
                  (View.Character.get_portrait_html model.player_id char),
                  (get_health_bar char),
                  (get_movement_bar model char)
               ]
            ),
            (get_weapon_details char_statistics main_weapon),
            (get_armor_details (Struct.Character.get_armor char)),
            (get_relevant_stats model char main_weapon),
            (get_weapon_summary secondary_weapon)
         ]
      )

get_full_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_full_html model char weapon =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-card")
      ]
      [
         (get_name char),
         (Html.div
            [
               (Html.Attributes.class "battlemap-character-card-top")
            ]
            [
               (View.Character.get_portrait_html model.player_id char),
               (get_health_bar char),
               (get_movement_bar model char)
            ]
         ),
         (get_weapon_details (Struct.Character.get_statistics char) weapon),
         (get_armor_details (Struct.Character.get_armor char)),
         (get_relevant_stats model char weapon)
      ]
   )
