module View.Character exposing
   (
      get_portrait_html,
      get_icon_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Roster Editor ---------------------------------------------------------------
import Util.Html

import Struct.Armor
import Struct.Character
import Struct.Event
import Struct.Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_icon_body_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_icon_body_html char =
   (Html.div
      [
         (Html.Attributes.class "battle-character-icon-body"),
         (Html.Attributes.class "asset-character-team-body-0")
      ]
      [
      ]
   )

get_icon_head_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_icon_head_html char =
   (Html.div
      [
         (Html.Attributes.class "battle-character-icon-head"),
         (Html.Attributes.class
            ("asset-character-icon-" ++ (Struct.Character.get_portrait_id char))
         )
      ]
      [
      ]
   )

get_portrait_body_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_portrait_body_html char =
   (Html.div
      [
         (Html.Attributes.class "battle-character-portrait-body"),
         (Html.Attributes.class
            (
               "asset-character-portrait-"
               ++ (Struct.Character.get_portrait_id char)
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
         (Html.Attributes.class "battle-character-portrait-armor"),
         (Html.Attributes.class
            (
               "asset-armor-"
               ++
               (Struct.Armor.get_image_id (Struct.Character.get_armor char))
            )
         ),
         (Html.Attributes.class
            (
               "asset-armor-variation-0"
               -- TODO: link this to the portrait.
            )
         )
      ]
      [
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_portrait_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_portrait_html char =
   (Html.div
      [
         (Html.Attributes.class "battle-character-portrait"),
         (Html.Attributes.class "battle-character-portrait-team-0")
      ]
      [
         (get_portrait_body_html char),
         (get_portrait_armor_html char)
      ]
   )

get_icon_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_icon_html char =
   (Html.div
      [
         (Html.Attributes.class "battle-tiled"),
         (Html.Attributes.class "battle-character-icon"),
         (Html.Attributes.class "clickable")
      ]
      [
         (get_icon_body_html char),
         (get_icon_head_html char)
      ]
   )
