module View.WeaponSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Roster Editor ---------------------------------------------------------------
import Struct.Event
import Struct.Model
import Struct.Weapon
import Struct.Omnimods

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
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
            (Html.text
               (category ++ ": " ++ (String.fromInt value))
            )
         ]
      )

get_weapon_html : (
      Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_html weapon =
   (Html.div
      [
         (Html.Attributes.class "character-card-weapon"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedWeapon (Struct.Weapon.get_id weapon))
         )
     ]
      [
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
                     (Html.text
                        (
                           "~"
                           ++
                           (String.fromInt
                              (Struct.Weapon.get_damage_sum weapon)
                           )
                           ++ " dmg @ ["
                           ++
                           (String.fromInt
                              (Struct.Weapon.get_defense_range weapon)
                           )
                           ++ ", "
                           ++
                           (String.fromInt
                              (Struct.Weapon.get_attack_range weapon)
                           )
                           ++ "]"
                        )
                     )
                  ]
               )
            ]
         ),
         (Html.div
            [
               (Html.Attributes.class "info-card-omnimods-listing")
            ]
            (List.map
               (get_mod_html)
               (Struct.Omnimods.get_all_mods (Struct.Weapon.get_omnimods weapon))
            )
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "selection-window"),
         (Html.Attributes.class "weapon-selection")
      ]
      [
         (Html.text "Weapon Selection"),
         (Html.div
            [
               (Html.Attributes.class "selection-window-listing")
            ]
            (List.map
               (get_weapon_html)
               (Dict.values model.weapons)
            )
         )
      ]
   )
