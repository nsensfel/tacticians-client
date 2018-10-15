module View.Character exposing
   (
      get_portrait_html,
      get_icon_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes

-- Roster Editor ---------------------------------------------------------------
import Struct.Armor
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
         (Html.Attributes.class "character-portrait-body"),
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
         (Html.Attributes.class "character-portrait"),
         (Html.Attributes.class "character-portrait-team-0")
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
         (Html.Attributes.class "tiled"),
         (Html.Attributes.class "character-icon"),
         (Html.Attributes.class "clickable")
      ]
      [
         (get_icon_body_html char),
         (get_icon_head_html char)
      ]
   )
