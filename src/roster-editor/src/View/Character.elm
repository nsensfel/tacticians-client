module View.Character exposing
   (
      get_portrait_html,
      get_icon_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Roster Editor ---------------------------------------------------------------
import Util.Html

import Struct.Armor
import Struct.Character
import Struct.Event
import Struct.Portrait

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
               ++ (Struct.Armor.get_image_id (Struct.Character.get_armor char))
            )
         )
      ]
      [
      ]
   )

get_portrait_body_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_portrait_body_html char =
   (Html.div
      [
         (Html.Attributes.class "character-portrait-body"),
         (Html.Attributes.class
            (
               "asset-character-portrait-"
               ++ (Struct.Portrait.get_id (Struct.Character.get_portrait char))
            )
         )
      ]
      [
      ]
   )

get_portrait_armor_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_portrait_armor_html char =
   (Html.div
      [
         (Html.Attributes.class "character-portrait-armor"),
         (Html.Attributes.class
            (
               "asset-armor-"
               ++
               (Struct.Armor.get_image_id (Struct.Character.get_armor char))
            )
         ),
         (Html.Attributes.class
            (
               "asset-armor-variation-"
               ++
               (Struct.Portrait.get_body_id
                  (Struct.Character.get_portrait char)
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
         (Util.Html.nothing)
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
      Struct.Character.Type ->
      Bool ->
      (Html.Html Struct.Event.Type)
   )
get_portrait_html char click_to_toggle =
   (Html.div
      (
         [
            (Html.Attributes.class "character-portrait"),
            (Html.Attributes.class "character-portrait-team-0")
         ]
         ++
         if (click_to_toggle)
         then
            [
               (Html.Events.onClick
                  (Struct.Event.ToggleCharacterBattleIndex
                     (Struct.Character.get_index char)
                  )
               )
            ]
         else
            []
      )
      [
         (get_portrait_body_html char),
         (get_portrait_armor_html char),
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
