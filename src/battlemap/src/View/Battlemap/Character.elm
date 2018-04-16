module View.Battlemap.Character exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Html
import Html.Attributes
import Html.Events

-- Battlemap  ------------------------------------------------------------------
import Constants.UI

import Util.Html

import Struct.Character
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_actual_html : (
      String ->
      Struct.Character.Type ->
      (Html.Html Struct.Event.Type)
   )
get_actual_html viewer_id char =
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
            (Html.Attributes.class
               (
                  if ((Struct.Character.get_player_id char) == viewer_id)
                  then
                     "battlemap-character-ally"
                  else
                     "battlemap-character-enemy"
               )
            ),
            (Html.Attributes.class "battlemap-tiled"),
            (Html.Attributes.class
               ("asset-character-icon-" ++ (Struct.Character.get_icon_id char))
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

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : String -> Struct.Character.Type -> (Html.Html Struct.Event.Type)
get_html viewer_id char =
   if (Struct.Character.is_alive char)
   then
      (get_actual_html viewer_id char)
   else
      (Util.Html.nothing)
