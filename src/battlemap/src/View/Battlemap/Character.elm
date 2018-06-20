module View.Battlemap.Character exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events
import Html.Lazy

-- Battlemap  ------------------------------------------------------------------
import Constants.UI

import Util.Html

import Struct.Character
import Struct.CharacterTurn
import Struct.Direction
import Struct.Event
import Struct.Model
import Struct.TurnResult
import Struct.TurnResultAnimator
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_animation_class : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Attribute Struct.Event.Type)
   )
get_animation_class model char =
   case model.animator of
      Nothing -> (Html.Attributes.class "")
      (Just animator) ->
         let
            current_action =
               (Struct.TurnResultAnimator.get_current_action animator)
         in
            if
            (
               (Struct.TurnResult.get_actor_index current_action)
               /=
               (Struct.Character.get_index char)
            )
            then
               (Html.Attributes.class "")
            else
               case current_action of
                  (Struct.TurnResult.Moved _) ->
                     (Html.Attributes.class "battlemap-animated-character-icon")

                  _ -> (Html.Attributes.class "")

get_activation_level_class : (
      Struct.Character.Type ->
      (Html.Attribute Struct.Event.Type)
   )
get_activation_level_class char =
   if (Struct.Character.is_enabled char)
   then
      (Html.Attributes.class "battlemap-character-icon-enabled")
   else
      (Html.Attributes.class "battlemap-character-icon-disabled")

get_alliance_class : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Attribute Struct.Event.Type)
   )
get_alliance_class model char =
   if ((Struct.Character.get_player_id char) == model.player_id)
   then
      (Html.Attributes.class "battlemap-character-ally")
   else
      (Html.Attributes.class "battlemap-character-enemy")

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
      (Html.Attributes.class "battlemap-character-selected")
   else
      if
      (
         (Struct.CharacterTurn.try_getting_target model.char_turn)
         ==
         (Just (Struct.Character.get_index char))
      )
      then
         (Html.Attributes.class "battlemap-character-targeted")
      else
         (Html.Attributes.class "")

get_body_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_body_html char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-icon-body"),
         (Html.Attributes.class
            (
               "asset-character-team-body-"
               ++ (Struct.Character.get_player_id char)
            )
         )
      ]
      [
      ]
   )

get_head_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_head_html char =
   (Html.div
      [
         (Html.Attributes.class "battlemap-character-icon-head"),
         (Html.Attributes.class
            ("asset-character-icon-" ++ (Struct.Character.get_icon_id char))
         )
      ]
      [
      ]
   )

get_actual_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_actual_html model char =
      (Html.div
         [
            (Html.Attributes.class "battlemap-tiled"),
            (Html.Attributes.class "battlemap-character-icon"),
            (get_animation_class model char),
            (get_activation_level_class char),
            (get_alliance_class model char),
            (get_position_style char),
            (get_focus_class model char),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick
               (Struct.Event.CharacterSelected
                  (Struct.Character.get_index char)
               )
            )
         ]
         [
            (get_body_html char),
            (get_head_html char)
         ]
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model char =
   if (Struct.Character.is_alive char)
   then
      (get_actual_html model char)
   else
      (Util.Html.nothing)
