module View.Map.Character exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Shared ----------------------------------------------------------------------
import Shared.Util.Html

-- Battle Characters -----------------------------------------------------------
import BattleCharacters.Struct.Portrait
import BattleCharacters.Struct.Character
import BattleCharacters.Struct.Equipment

-- Local Module ----------------------------------------------------------------
import Constants.UI

import Struct.Character
import Struct.Event
import Struct.UI

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
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

get_body_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_body_html char =
   (Html.div
      [
         (Html.Attributes.class "character-icon-body"),
         (Html.Attributes.class
            (
               "asset-character-team-body-"
               ++ (String.fromInt (Struct.Character.get_player_index char))
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
            ("asset-character-icon-" ++
               (BattleCharacters.Struct.Portrait.get_icon_id
                  (BattleCharacters.Struct.Equipment.get_portrait
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

get_banner_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_banner_html char =
   -- TODO: Banner from some status indicator
   (Shared.Util.Html.nothing)

get_actual_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_actual_html char =
      (Html.div
         (
            [
               (Html.Attributes.class "tiled"),
               (Html.Attributes.class "character-icon"),
               (Html.Attributes.class "clickable"),
               (Html.Events.onClick
                  (Struct.Event.CharacterSelected
                     (Struct.Character.get_index char)
                  )
               )
            ]
            ++
            (List.map
               (
                  \effect_name ->
                     (Html.Attributes.class
                        ("character-icon-effect-" ++ effect_name)
                     )
               )
               (Struct.Character.get_extra_display_effects_list char)
            )
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
get_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_html char =
   if (Struct.Character.is_alive char)
   then (get_actual_html char)
   else (Shared.Util.Html.nothing)
