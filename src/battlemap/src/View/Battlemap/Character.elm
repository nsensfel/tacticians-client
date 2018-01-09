module View.Battlemap.Character exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap  ------------------------------------------------------------------
import Constants.UI

import Struct.Character
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_html char =
   let
      char_loc = (Struct.Character.get_location char)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-character-icon"),
            (Html.Attributes.class
               (
                  if (Struct.Character.is_enabled char)
                  then
                     "battlemap-character-icon-enabled"
                  else
                     "battlemap-character-icon-disabled"
               )
            ),
            (Html.Attributes.class "battlemap-tiled"),
            (Html.Attributes.class
               ("asset-character-icon-" ++ (Struct.Character.get_icon_id char))
            ),
            (Html.Attributes.class
               (
                  "battlemap-character-team-"
                  ++ (toString (Struct.Character.get_team char))
               )
            ),
            (Html.Attributes.class "clickable"),
            (Html.Events.onClick
               (Struct.Event.CharacterSelected (Struct.Character.get_ref char))
            ),
            (Html.Attributes.style
               [
                  (
                     "top",
                     ((toString (char_loc.y * Constants.UI.tile_size)) ++ "px")
                  ),
                  (
                     "left",
                     ((toString (char_loc.x * Constants.UI.tile_size)) ++ "px")
                  )
               ]
            )
         ]
         [
         ]
      )

