module View.Character exposing
   (
      get_portrait_html,
      get_icon_html
   )

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map  ------------------------------------------------------------------
import Constants.UI

import Util.Html

import Struct.Armor
import Struct.Character
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_activation_level_class : (
      Struct.Character.Type ->
      (Html.Attribute Struct.Event.Type)
   )
get_activation_level_class char =
   if (Struct.Character.is_enabled char)
   then
      (Html.Attributes.class "character-icon-enabled")
   else
      (Html.Attributes.class "character-icon-disabled")

get_alliance_class : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Attribute Struct.Event.Type)
   )
get_alliance_class model char =
   if ((Struct.Character.get_player_ix char) == model.player_ix)
   then
      (Html.Attributes.class "character-ally")
   else
      (Html.Attributes.class "character-enemy")

get_position_style : (
      Struct.Character.Type ->
      (Html.Attribute Struct.Event.Type)
   )
get_position_style char =
   let char_loc = (Struct.Character.get_location char) in
      (Html.Attributes.style
         [
            ("top", ((toString (char_loc.y * Constants.UI.tile_size)) ++ "px")),
            ("left", ((toString (char_loc.x * Constants.UI.tile_size)) ++ "px"))
         ]
      )

get_focus_class : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Attribute Struct.Event.Type)
   )
get_focus_class model char =
   if
   (
      (Struct.UI.get_previous_action model.ui)
      ==
      (Just (Struct.UI.SelectedCharacter (Struct.Character.get_index char)))
   )
   then
      (Html.Attributes.class "character-selected")
   else
      if
      (
         (Struct.CharacterTurn.try_getting_target model.char_turn)
         ==
         (Just (Struct.Character.get_index char))
      )
      then
         (Html.Attributes.class "character-targeted")
      else
         (Html.Attributes.class "")

get_icon_body_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_icon_body_html char =
   (Html.div
      [
         (Html.Attributes.class "character-icon-body"),
         (Html.Attributes.class
            (
               "asset-character-team-body-"
               ++ (toString (Struct.Character.get_player_ix char))
            )
         )
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
            ("asset-character-icon-" ++ (Struct.Character.get_icon_id char))
         )
      ]
      [
      ]
   )

get_icon_actual_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_icon_actual_html model char =
      (Html.div
         [
            (Html.Attributes.class "tiled"),
            (Html.Attributes.class "character-icon"),
            (get_activation_level_class char),
            (get_alliance_class model char),
            (get_position_style char),
            (get_focus_class model char),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick
               (Struct.Event.CharacterSelected (Struct.Character.get_index char))
            )
         ]
         [
            (get_icon_body_html char),
            (get_icon_head_html char)
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
               "asset-armor-variation-"
               ++ (Struct.Character.get_armor_variation char)
            )
         )
      ]
      [
      ]
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_portrait_html : (
      Int ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_portrait_html viewer_ix char =
   (Html.div
      [
         (Html.Attributes.class
            (
               if ((Struct.Character.get_player_ix char) == viewer_ix)
               then
                  "character-ally"
               else
                  "character-enemy"
            )
         ),
         (Html.Attributes.class "character-portrait"),
         (Html.Attributes.class
            (
               "character-portrait-team-"
               ++
               (toString (Struct.Character.get_player_ix char))
            )
         ),
         (Html.Events.onClick
            (Struct.Event.LookingForCharacter (Struct.Character.get_index char))
         )
      ]
      [
         (get_portrait_body_html char),
         (get_portrait_armor_html char)
      ]
   )

get_icon_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_icon_html model char =
   if (Struct.Character.is_alive char)
   then
      (get_icon_actual_html model char)
   else
      (Util.Html.nothing)
