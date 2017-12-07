module View.SideBar.Targets exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Struct.Battlemap
import Struct.Character
import Struct.CharacterTurn
import Struct.Error
import Struct.Event
import Struct.Location
import Struct.Model
import Struct.Tile
import Struct.UI

import Util.Html

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
               ++ " (Team "
               ++ (toString (Struct.Character.get_team char))
               ++ "): "
               ++ (toString (Struct.Character.get_movement_points char))
               ++ " movement points; "
               ++ (toString (Struct.Character.get_attack_range char))
               ++ " attack range. Health: "
               ++ (toString (Struct.Character.get_current_health char))
               ++ "/"
               ++ (toString (Struct.Character.get_max_health char))
            )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Struct.Model.Type -> (Html.Html Struct.Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-side-bar-targets")
      ]
      (List.map
         (get_target_info_html model)
         (Struct.CharacterTurn.get_targets model.char_turn)
      )
   )
