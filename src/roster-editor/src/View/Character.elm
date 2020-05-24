module View.Character exposing
   (
      get_portrait_html,
      get_icon_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Shared ----------------------------------------------------------------------
import Shared.Util.Html

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Armor
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment

import BattleCharacters.View.Portrait

-- Local Module ----------------------------------------------------------------
import Struct.Character
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon_body_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_icon_body_html char =
   (Html.div
      [
         (Html.Attributes.class "character-icon-body"),
         (Html.Attributes.class "asset-character-team-body-0")
      ]
      [
      ]
   )

get_icon_head_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_icon_head_html char =
   (Html.div
      [
         (Html.Attributes.class "character-icon-head"),
         (Html.Attributes.class
            (
               "asset-character-icon-"
               ++
               (BattleCharacters.Struct.Armor.get_image_id
                  (BattleCharacters.Struct.Equipment.get_armor
                     (BattleCharacters.Struct.Character.get_equipment
                        (Struct.Character.get_base_character char)
                     )
                  )
               )
            )
         )
      ]
      [
      ]
   )

get_battle_index_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_battle_index_html char =
   let battle_ix = (Struct.Character.get_battle_index char) in
      if (battle_ix == -1)
      then
         (Shared.Util.Html.nothing)
      else
         (Html.div
            [
               (Html.Attributes.class "character-portrait-battle-index"),
               (Html.Attributes.class "clickable")
            ]
            [
               (Html.text (String.fromInt battle_ix))
            ]
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_portrait_html : (
      Bool ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_portrait_html click_to_toggle char =
   (Html.div
      []
      [
         (BattleCharacters.View.Portrait.get_html
            (
               if (click_to_toggle)
               then
                  [
                     (Html.Events.onClick
                        (Struct.Event.ToggleCharacterBattleIndex
                           (Struct.Character.get_index char)
                        )
                     ),
                     (Html.Attributes.class "character-portrait-team-0")
                  ]
               else
                  [(Html.Attributes.class "character-portrait-team-0")]
            )
            (BattleCharacters.Struct.Character.get_equipment
               (Struct.Character.get_base_character char)
            )
         ),
         (get_battle_index_html char)
      ]
   )

get_icon_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_icon_html char =
   (Html.div
      [
         (Html.Attributes.class "tiled"),
         (Html.Attributes.class "character-icon"),
         (Html.Attributes.class "clickable")
      ]
      [
         (get_icon_body_html char),
         (get_icon_head_html char)
      ]
   )
