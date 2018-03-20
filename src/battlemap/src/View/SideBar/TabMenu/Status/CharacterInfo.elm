module View.SideBar.TabMenu.Status.CharacterInfo exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Attributes
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.Statistics
import Struct.Weapon
import Struct.WeaponSet

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_attributes_html: (
      Struct.Attributes.Type ->
      (Html.Html Struct.Event.Type)
   )
get_attributes_html att =
   (Html.ul
      [
      ]
      [
         (Html.li
            []
            [
               (Html.text
                  (
                     "Constitution: "
                     ++ (toString (Struct.Attributes.get_constitution att))
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Dexterity: "
                     ++ (toString (Struct.Attributes.get_dexterity att))
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Intelligence: "
                     ++ (toString (Struct.Attributes.get_intelligence att))
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Mind: "
                     ++ (toString (Struct.Attributes.get_mind att))
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Speed: "
                     ++ (toString (Struct.Attributes.get_speed att))
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Strength: "
                     ++ (toString (Struct.Attributes.get_strength att))
                  )
               )
            ]
         )
      ]
   )

get_statistics_html : (
      Struct.Statistics.Type ->
      (Html.Html Struct.Event.Type)
   )
get_statistics_html stats =
   (Html.ul
      [
      ]
      [
         (Html.li
            []
            [
               (Html.text
                  (
                     "Chance to Dodge (Base): "
                     ++ (toString (Struct.Statistics.get_dodges stats))
                     ++ "%"
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Chance to Parry: "
                     ++ (toString (Struct.Statistics.get_parries stats))
                     ++ "%"
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Actual Damage: ["
                     ++ (toString (Struct.Statistics.get_damage_min stats))
                     ++ ", "
                     ++ (toString (Struct.Statistics.get_damage_max stats))
                     ++ "]"
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Accuracy: "
                     ++ (toString (Struct.Statistics.get_accuracy stats))
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Chance to Double Hit: "
                     ++ (toString (Struct.Statistics.get_double_hits stats))
                     ++ "%"
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Chance to Critical Hit: "
                     ++ (toString (Struct.Statistics.get_critical_hits stats))
                     ++ "%"
                  )
               )
            ]
         )
      ]
   )

get_weapon_name_html : Struct.Weapon.Type ->  (Html.Html Struct.Event.Type)
get_weapon_name_html wp =
   (Html.text
      (
         (Struct.Weapon.get_name wp)
         ++ " ("
         ++
         (case (Struct.Weapon.get_range_modifier wp) of
            Struct.Weapon.Short -> "Short"
            Struct.Weapon.Long -> "Long"
         )
         ++ " "
         ++
         (case (Struct.Weapon.get_damage_modifier wp) of
            Struct.Weapon.Heavy -> "Heavy"
            Struct.Weapon.Light -> "Light"
         )
         ++ " "
         ++
         (case (Struct.Weapon.get_range_type wp) of
            Struct.Weapon.Ranged -> "Ranged"
            Struct.Weapon.Melee -> "Melee"
         )
         ++ ")"
      )
   )

get_weapon_html : Struct.Weapon.Type -> (Html.Html Struct.Event.Type)
get_weapon_html wp =
   (Html.ul
      [
      ]
      [
         (Html.li
            []
            [ (get_weapon_name_html wp) ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Damage: ["
                     ++ (toString (Struct.Weapon.get_min_damage wp))
                     ++ ", "
                     ++ (toString (Struct.Weapon.get_max_damage wp))
                     ++ "] "
                     ++
                     (case (Struct.Weapon.get_damage_type wp) of
                        Struct.Weapon.Slash -> "Slashing"
                        Struct.Weapon.Pierce -> "Piercing"
                        Struct.Weapon.Blunt -> "Bludgeoning"
                     )
                  )
               )
            ]
         ),
         (Html.li
            []
            [
               (Html.text
                  (
                     "Range: ("
                     ++ (toString (Struct.Weapon.get_defense_range wp))
                     ++ ", "
                     ++ (toString (Struct.Weapon.get_attack_range wp))
                     ++ ")"
                  )
               )
            ]
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html: (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model char =
   (Html.div
      [
            (Html.Attributes.class "battlemap-tabmenu-character-info")
      ]
      [
         (Html.text ("Focusing " ++ char.name ++ ":")),
         (Html.dl
            [
            ]
            [
               (Html.dt [] [(Html.text "Location")]),
               (Html.dd
                  []
                  (
                     let
                        location = (Struct.Character.get_location char)
                     in
                        [
                           (Html.text
                              (
                                 (toString location.x)
                                 ++
                                 ", "
                                 ++
                                 (toString location.y)
                              )
                           )
                        ]
                  )
               ),
               (Html.dt [] [(Html.text "Player")]),
               (Html.dd
                  []
                  [
                     (Html.text
                        (Struct.Character.get_player_id char)
                     )
                  ]
               ),
               (Html.dt [] [(Html.text "Health")]),
               (Html.dd
                  []
                  [
                     (Html.text
                        (
                           (toString
                              (Struct.Character.get_current_health char)
                           )
                           ++ "/"
                           ++
                           (toString
                              (Struct.Statistics.get_max_health
                                 (Struct.Character.get_statistics char)
                              )
                           )
                        )
                     )
                  ]
               ),
               (Html.dt [] [(Html.text "Movement Points")]),
               (Html.dd
                  []
                  [
                     (Html.text
                        (toString
                           (Struct.Statistics.get_movement_points
                              (Struct.Character.get_statistics char)
                           )
                        )
                     )
                  ]
               ),
               (Html.dt [] [(Html.text "Active Weapon:")]),
               (Html.dd
                  []
                  [
                     (get_weapon_html
                        (Struct.WeaponSet.get_active_weapon
                           (Struct.Character.get_weapons char)
                        )
                     )
                  ]
               ),
               (Html.dt [] [(Html.text "Secondary Weapon:")]),
               (Html.dd
                  []
                  [
                     (get_weapon_html
                        (Struct.WeaponSet.get_secondary_weapon
                           (Struct.Character.get_weapons char)
                        )
                     )
                  ]
               )
            ]
         ),
         (get_attributes_html (Struct.Character.get_attributes char)),
         (get_statistics_html (Struct.Character.get_statistics char))
      ]
   )
