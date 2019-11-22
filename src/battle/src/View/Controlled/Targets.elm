module View.SideBar.Targets exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battle ----------------------------------------------------------------------
import Battle.Struct.Attributes

-- Local Module ----------------------------------------------------------------
import Struct.Battle
import Struct.Character
import Struct.Event

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

get_target_info_html : (
      Struct.Battle.Type ->
      Struct.Character.Ref ->
      (Html.Html Struct.Event.Type)
   )
get_target_info_html battle char_ref =
   case (Struct.Battle.get_character char_ref battle) of
      Nothing -> (Html.text "Error: Unknown character selected.")
      (Just char) ->
         (Html.text
            (
               "Attacking "
               ++ char.name
               ++ " (player "
               ++ (String.fromInt (Struct.Character.get_player_index char))
               ++ "): "
               ++
               (String.fromInt
                  (Battle.Struct.Attributes.get_movement_points
                     (Struct.Character.get_attributes char)
                  )
               )
               ++ " movement points; "
               ++ "???"
               ++ " attack range. Health: "
               ++
               (String.fromInt
                  (Struct.Character.get_sane_current_health char)
               )
               ++ "/"
               ++
               (String.fromInt
                  (Battle.Struct.Attributes.get_max_health
                     (Struct.Character.get_attributes char)
                  )
               )
            )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Battle.Type ->
      Struct.Character.Ref ->
      (Html.Html Struct.Event.Type)
   )
get_html battle target_ref =
   (Html.div
      [
         (Html.Attributes.class "side-bar-targets")
      ]
      [(get_target_info_html battle target_ref)]
   )
