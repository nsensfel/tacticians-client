module View.SideBar.Targets exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Location
import Battlemap.Tile

import Character

import UI

import Util.Html

import Error
import Event
import Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------

get_target_info_html : Model.Type -> Character.Ref -> (Html.Html Event.Type)
get_target_info_html model char_ref =
   case (Dict.get char_ref model.characters) of
      Nothing -> (Html.text "Error: Unknown character selected.")
      (Just char) ->
         (Html.text
            (
               "Attacking "
               ++ char.name
               ++ " (Team "
               ++ (toString (Character.get_team char))
               ++ "): "
               ++ (toString (Character.get_movement_points char))
               ++ " movement points; "
               ++ (toString (Character.get_attack_range char))
               ++ " attack range. Health: "
               ++ (toString (Character.get_current_health char))
               ++ "/"
               ++ (toString (Character.get_max_health char))
            )
         )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-side-bar-targets")
      ]
      (List.map
         (get_target_info_html model)
         model.targets
      )
   )
