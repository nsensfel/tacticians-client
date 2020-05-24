module View.WeaponSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Lazy
import Html.Attributes
import Html.Events

-- Shared ----------------------------------------------------------------------
import Shared.Util.Html

-- Battle ----------------------------------------------------------------------
import Battle.View.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.DataSet
import BattleCharacters.Struct.Weapon

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
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
         (Battle.View.Omnimods.get_signed_html
            (BattleCharacters.Struct.Weapon.get_omnimods weapon)
         )
      ]
   )

get_weapon_htmls : (
      Bool ->
      BattleCharacters.Struct.DataSet.Type ->
      (List (Html.Html Struct.Event.Type))
   )
get_weapon_htmls is_selecting_secondary dataset =
   if (is_selecting_secondary)
   then
      (List.filterMap
         (\wp ->
            if (BattleCharacters.Struct.Weapon.get_is_primary wp)
            then Nothing
            else (Just (get_weapon_html wp))
         )
         (Dict.values
            (BattleCharacters.Struct.DataSet.get_weapons dataset)
         )
      )
   else
      (List.map
         (get_weapon_html)
         (Dict.values
            (BattleCharacters.Struct.DataSet.get_weapons dataset)
         )
      )

true_get_html : (
      Bool ->
      BattleCharacters.Struct.DataSet.Type ->
      (Html.Html Struct.Event.Type)
   )
true_get_html is_selecting_secondary dataset =
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
            (get_weapon_htmls is_selecting_secondary dataset)
         )
      ]
   )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   case model.edited_char of
      Nothing -> (Shared.Util.Html.nothing)
      (Just char) ->
         let
            is_selecting_secondary =
               (BattleCharacters.Struct.Character.is_using_secondary
                  (Struct.Character.get_base_character char)
               )
         in
            (Html.Lazy.lazy2
               (true_get_html)
               is_selecting_secondary
               model.characters_dataset
            )
