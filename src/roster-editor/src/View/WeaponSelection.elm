module View.WeaponSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Battle ----------------------------------------------------------------------
import Battle.View.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Weapon

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

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

get_weapon_html : (
      BattleCharacters.Struct.Weapon.Type ->
      (Html.Html Struct.Event.Type)
   )
get_weapon_html weapon =
   (Html.div
      [
         (Html.Attributes.class "character-card-weapon"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedWeapon
               (BattleCharacters.Struct.Weapon.get_id weapon)
            )
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
                     (Html.text
                        (BattleCharacters.Struct.Weapon.get_name weapon)
                     )
                  ]
               ),
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
                     (BattleCharacters.Struct.Weapon.get_damage_sum weapon)
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
         ),
         (Battle.View.Omnimods.get_html
            (BattleCharacters.Struct.Weapon.get_omnimods weapon)
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case model.edited_char of
      Nothing -> (Util.Html.nothing)
      (Just char) ->
         let
            is_selecting_secondary =
               (Struct.Character.get_is_using_secondary char)
         in
            (Html.div
               [
                  (Html.Attributes.class "selection-window"),
                  (Html.Attributes.class "weapon-selection")
               ]
               [
                  (Html.text
                     (
                        if (is_selecting_secondary)
                        then "Secondary Weapon Selection"
                        else "Primary Weapon Selection"
                     )
                  ),
                  (Html.div
                     [
                        (Html.Attributes.class "selection-window-listing")
                     ]
                     (List.map
                        (get_weapon_html)
                        (List.filter
                           (\e ->
                              (not
                                 (
                                    is_selecting_secondary
                                    &&
                                    (BattleCharacters.Struct.Weapon.get_is_primary
                                       e
                                    )
                                 )
                              )
                           )
                           (Dict.values model.weapons)
                        )
                     )
                  )
               ]
            )
