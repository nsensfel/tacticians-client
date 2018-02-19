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
                     "Chance to Dodge (Graze): "
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
                     "Damage: ["
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
                     "Chance to Hit: "
                     ++ (toString (Struct.Statistics.get_accuracy stats))
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

get_weapon_html : (
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_html wp =
   (Html.ul
      [
      ]
      [
         (Html.li
            []
            [
               (Html.text
                  (
                     ""
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
               (Html.dt [] [(Html.text "Team")]),
               (Html.dd
                  []
                  [
                     (Html.text
                        (toString
                           (Struct.Character.get_team char)
                        )
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
               (Html.dt [] [(Html.text "Attack Range")]),
               (Html.dd
                  []
                  [
                     (Html.text "???")
                  ]
               )
            ]
         ),
         (get_attributes_html (Struct.Character.get_attributes char)),
         (get_statistics_html (Struct.Character.get_statistics char))
      ]
   )
