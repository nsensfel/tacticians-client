module View.ArmorSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events
import Html.Lazy

-- Battle ----------------------------------------------------------------------
import Battle.View.Omnimods

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.DataSet

-- Local Module ----------------------------------------------------------------
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
            (Html.text
               (category ++ ": " ++ (String.fromInt value))
            )
         ]
      )

get_armor_html : (
      BattleCharacters.Struct.Armor.Type ->
      (Html.Html Struct.Event.Type)
   )
get_armor_html armor =
   (Html.div
      [
         (Html.Attributes.class "character-card-armor"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedArmor
               (BattleCharacters.Struct.Armor.get_id armor)
            )
         )
      ]
      [
         (Html.div
            [
               (Html.Attributes.class "character-card-armor-name")
            ]
            [
               (Html.text
                  (BattleCharacters.Struct.Armor.get_name armor)
               )
            ]
         ),
         (Battle.View.Omnimods.get_signed_html
            (BattleCharacters.Struct.Armor.get_omnimods armor)
         )
      ]
   )

true_get_html : (
      BattleCharacters.Struct.DataSet.Type ->
      (Html.Html Struct.Event.Type)
   )
true_get_html dataset =
   (Html.div
      [
         (Html.Attributes.class "selection-window"),
         (Html.Attributes.class "armor-selection")
      ]
      [
         (Html.text "Armor Selection"),
         (Html.div
            [
               (Html.Attributes.class "selection-window-listing")
            ]
            (List.map
               (get_armor_html)
               (Dict.values
                  (BattleCharacters.Struct.DataSet.get_armors dataset)
               )
            )
         )
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.Lazy.lazy
      (true_get_html)
      model.characters_dataset
   )
