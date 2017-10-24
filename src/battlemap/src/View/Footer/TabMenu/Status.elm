module View.Footer.TabMenu.Status exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Dict

import Html
import Html.Attributes

-- Battlemap -------------------------------------------------------------------
import Battlemap
import Battlemap.Location
import Battlemap.Tile

import Character

import Util.Html

import Error
import Event
import Model

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_char_info_html : Model.Type -> Character.Ref -> (Html.Html Event.Type)
get_char_info_html model char_ref =
   case (Dict.get char_ref model.characters) of
      Nothing -> (Html.text "Error: Unknown character selected.")
      (Just char) ->
         (Html.text
            (
               "Controlling "
               ++ char.name
               ++ ": "
               ++ (toString
                     (Battlemap.get_navigator_remaining_points
                        model.battlemap
                     )
                  )
               ++ "/"
               ++ (toString (Character.get_movement_points char))
               ++ " movement points remaining."
            )
         )

get_error_html : Error.Type -> (Html.Html Event.Type)
get_error_html err =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer-tabmenu-status-error-msg")
      ]
      [
         (Html.text (Error.to_string err))
      ]
   )

get_tile_info_html : (
      Model.Type ->
      Battlemap.Location.Type ->
      (Html.Html Event.Type)
   )
get_tile_info_html model loc =
   case (Battlemap.try_getting_tile_at model.battlemap loc) of
      (Just tile) ->
         (Html.div
            [
               (Html.Attributes.class
                  "battlemap-footer-tabmenu-content-status-tile-info"
               )
            ]
            [
               (Html.div
                  [
                     (Html.Attributes.class "battlemap-tile-icon"),
                     (Html.Attributes.class "battlemap-tiled"),
                     (Html.Attributes.class
                        (
                           "asset-tile-"
                           ++ (toString (Battlemap.Tile.get_icon_id tile))
                        )
                     )
                  ]
                  [
                  ]
               ),
               (Html.div
                  [
                  ]
                  [
                     (Html.text
                        (
                           "Focusing tile ("
                           ++ (toString loc.x)
                           ++ ", "
                           ++ (toString loc.y)
                           ++ ")."
                        )
                     )
                  ]
               )
            ]
         )

      Nothing -> (Html.text "Error: Unknown tile location selected.")
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : Model.Type -> (Html.Html Event.Type)
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-footer-tabmenu-content"),
         (Html.Attributes.class "battlemap-footer-tabmenu-content-status")
      ]
      [
         (case model.error of
            (Just error) -> (get_error_html error)
            Nothing -> Util.Html.nothing
         ),
         (case model.state of
            Model.Default -> (Html.text "Click on a character to control it.")
            (Model.FocusingTile tile_loc) ->
               (get_tile_info_html model (Battlemap.Location.from_ref tile_loc))

            (Model.MovingCharacterWithButtons char_ref) ->
               (get_char_info_html model char_ref)

            (Model.MovingCharacterWithClick char_ref) ->
               (get_char_info_html model char_ref)
         )
      ]
   )
