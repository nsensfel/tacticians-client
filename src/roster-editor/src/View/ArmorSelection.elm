module View.ArmorSelection exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes
import Html.Events

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
import Struct.Event
import Struct.Model
import Struct.Omnimods

import View.Omnimods
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
      Struct.Armor.Type ->
      (Html.Html Struct.Event.Type)
   )
get_armor_html armor =
   (Html.div
      [
         (Html.Attributes.class "character-card-armor"),
         (Html.Attributes.class "clickable"),
         (Html.Events.onClick
            (Struct.Event.SelectedArmor (Struct.Armor.get_id armor))
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
         (View.Omnimods.get_html 1.0 (Struct.Armor.get_omnimods armor))
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
         (Html.Attributes.class "armor-selection")
      ]
      [
         (Html.text "Armor Selection"),
         (Html.div
            [
               (Html.Attributes.class "selection-window-listing")
            ]
            (List.map (get_armor_html) (Dict.values model.armors))
         )
      ]
   )
