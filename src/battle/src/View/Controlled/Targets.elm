module View.SideBar.Targets exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Map -------------------------------------------------------------------
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.Statistics

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

get_target_info_html : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      (Html.Html Struct.Event.Type)
   )
get_target_info_html model char_ref =
   case (Dict.get char_ref model.characters) of
      Nothing -> (Html.text "Error: Unknown character selected.")
      (Just char) ->
         (Html.text
            (
               "Attacking "
               ++ char.name
               ++ " (player "
               ++ (toString (Struct.Character.get_player_ix char))
               ++ "): "
               ++
               (toString
                  (Struct.Statistics.get_movement_points
                     (Struct.Character.get_statistics char)
                  )
               )
               ++ " movement points; "
               ++ "???"
               ++ " attack range. Health: "
               ++ (toString (Struct.Character.get_sane_current_health char))
               ++ "/"
               ++
               (toString
                  (Struct.Statistics.get_max_health
                     (Struct.Character.get_statistics char)
                  )
               )
            )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      Struct.Character.Ref ->
      (Html.Html Struct.Event.Type)
   )
get_html model target_ref =
   (Html.div
      [
         (Html.Attributes.class "side-bar-targets")
      ]
      [(get_target_info_html model target_ref)]
   )
