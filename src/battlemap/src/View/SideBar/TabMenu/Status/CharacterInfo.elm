module View.SideBar.TabMenu.Status.CharacterInfo exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Struct.Battlemap -------------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_attributes_list: (
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_attributes_list char =
   (Html.ul
      [
      ]
      [
         (Html.li [] [(Html.text "Agility: ???")]),
         (Html.li [] [(Html.text "Dexterity: ???")]),
         (Html.li [] [(Html.text "Sight: ???")]),
         (Html.li [] [(Html.text "Strength: ???")])
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
                              (Struct.Character.get_max_health char)
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
                           (Struct.Character.get_movement_points char)
                        )
                     )
                  ]
               ),
               (Html.dt [] [(Html.text "Attack Range")]),
               (Html.dd
                  []
                  [
                     (Html.text
                        (toString
                           (Struct.Character.get_attack_range char)
                        )
                     )
                  ]
               )
            ]
         )
      ]
   )
