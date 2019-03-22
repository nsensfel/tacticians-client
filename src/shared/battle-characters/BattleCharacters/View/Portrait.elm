module BattleCharacters.View.Portrait exposing
   (
      get_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Shared ----------------------------------------------------------------------
import Util.Html

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Equipment
import BattleCharacters.Struct.Portrait

-- Local Module ----------------------------------------------------------------
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_portrait_body_html : (
      BattleCharacters.Struct.Equipment.Type ->
      (Html.Html Struct.Event.Type)
   )
get_portrait_body_html equipment =
   (Html.div
      [
         (Html.Attributes.class "character-portrait-body"),
         (Html.Attributes.class
            (
               "asset-character-portrait-"
               ++
               (BattleCharacters.Struct.Portrait.get_id
                  (BattleCharacters.Struct.Equipment.get_portrait equipment)
               )
            )
         )
      ]
      [
      ]
   )

get_portrait_armor_html : (
      BattleCharacters.Struct.Equipment.Type ->
      (Html.Html Struct.Event.Type)
   )
get_portrait_armor_html equipment =
   (Html.div
      [
         (Html.Attributes.class "character-portrait-armor"),
         (Html.Attributes.class
            (
               "asset-armor-"
               ++
               (BattleCharacters.Struct.Armor.get_image_id
                  (BattleCharacters.Equipment.get_armor equipment)
               )
            )
         ),
         (Html.Attributes.class
            (
               "asset-armor-variation-"
               ++
               (BattleCharacters.Struct.Portrait.get_body_id
                  (BattleCharacters.Struct.Equipment.get_portrait equipment)
               )
            )
         )
      ]
      [
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      (List (Html.Attribute Struct.Event.Type)) ->
      BattleCharacters.Equipment.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html extra_attributes equipment =
   (Html.div
      (
         [
            (Html.Attributes.class "character-portrait")
         ]
         ++
         extra_attributes
      )
      [
         (get_portrait_body_html equipment),
         (get_portrait_armor_html equipment)
      ]
   )
