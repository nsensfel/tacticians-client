module View.Map.Character exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Map  ------------------------------------------------------------------
import Constants.UI

import Util.Html

import Struct.Character
import Struct.CharacterTurn
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
         case (Struct.TurnResultAnimator.get_current_animation animator) of
            (Struct.TurnResultAnimator.Focus char_index) ->
               if ((Struct.Character.get_index char) /= char_index)
               then
                  (Html.Attributes.class "")
               else
                  (Html.Attributes.class "character-selected")

            (Struct.TurnResultAnimator.TurnResult current_action) ->
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
                        (Html.Attributes.class
                           "animated-character-icon"
                        )

                     _ -> (Html.Attributes.class "")
            _ -> (Html.Attributes.class "")

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
      (List (Html.Attribute Struct.Event.Type))
   )
get_position_style char =
   let char_loc = (Struct.Character.get_location char) in
      [
         (Html.Attributes.style
            "top"
            ((String.fromInt (char_loc.y * Constants.UI.tile_size)) ++ "px")
         ),
         (Html.Attributes.style
            "left"
            ((String.fromInt (char_loc.x * Constants.UI.tile_size)) ++ "px")
         )
      ]

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

get_body_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_body_html char =
   (Html.div
      [
         (Html.Attributes.class "character-icon-body"),
         (Html.Attributes.class
            (
               "asset-character-team-body-"
               ++ (String.fromInt (Struct.Character.get_player_ix char))
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
         (Html.Attributes.class "character-icon-head"),
         (Html.Attributes.class
            ("asset-character-icon-" ++ (Struct.Character.get_icon_id char))
         )
      ]
      [
      ]
   )

get_banner_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_banner_html char =
   case (Struct.Character.get_rank char) of
      Struct.Character.Commander ->
         (Html.div
            [
               (Html.Attributes.class "character-icon-banner"),
               (Html.Attributes.class "asset-character-icon-commander-banner")
            ]
            [
            ]
         )

      Struct.Character.Target ->
         (Html.div
            [
               (Html.Attributes.class "character-icon-banner"),
               (Html.Attributes.class "asset-character-icon-target-banner")
            ]
            [
            ]
         )

      _ -> (Util.Html.nothing)

get_actual_html : (
      Struct.Model.Type ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_actual_html model char =
      (Html.div
         (
            [
               (Html.Attributes.class "tiled"),
               (Html.Attributes.class "character-icon"),
               (get_animation_class model char),
               (get_activation_level_class char),
               (get_alliance_class model char),
               (get_focus_class model char),
               (Html.Attributes.class "clickable"),
               (Html.Events.onClick
                  (Struct.Event.CharacterSelected
                     (Struct.Character.get_index char)
                  )
               )
            ]
            ++
            (get_position_style char)
         )
         [
            (get_body_html char),
            (get_head_html char),
            (get_banner_html char)
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
