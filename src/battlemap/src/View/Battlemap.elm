module View.Battlemap exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import List

import Html
import Html.Attributes
import Html.Events
import Html.Lazy

-- Battlemap  ------------------------------------------------------------------
import Battlemap
import Battlemap.Tile

import Character

import Constants.UI

import Util.Html

import View.Battlemap.Tile
import View.Battlemap.Navigator

import Event
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
char_on_map : Character.Type -> (Html.Html Event.Type)
char_on_map char =
   let
      char_loc = (Character.get_location char)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-character-icon"),
            (Html.Attributes.class
               (
                  if (Character.is_enabled char)
                  then
                     "battlemap-character-icon-enabled"
                  else
                     "battlemap-character-icon-disabled"
               )
            ),
            (Html.Attributes.class "battlemap-tiled"),
            (Html.Attributes.class
               ("asset-character-icon-" ++ (Character.get_icon_id char))
            ),
            (Html.Attributes.class
               (
                  "battlemap-character-team-"
                  ++ (toString (Character.get_team char))
               )
            ),
            (Html.Events.onClick
               (Event.CharacterSelected (Character.get_ref char))
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

get_tiles_line_html : (List (Html.Html Event.Type)) -> (Html.Html Event.Type)
get_tiles_line_html tiles_list =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tiles-layer-row")
      ]
      tiles_list
   )

get_tiles_lines_html : (
      Int ->
      Battlemap.Tile.Type ->
      (
         Int,
         (List (Html.Html Event.Type)),
         (List (Html.Html Event.Type))
      ) ->
      (
         Int,
         (List (Html.Html Event.Type)),
         (List (Html.Html Event.Type))
      )
   )
get_tiles_lines_html max_index tile (curr_index, curr_line, result) =
   if (curr_index == 0)
   then
      (
         max_index,
         [],
         (
            (get_tiles_line_html
               ((View.Battlemap.Tile.get_html tile) :: curr_line)
            )
            ::
            result
         )
      )
   else
      (
         (curr_index - 1),
         ((View.Battlemap.Tile.get_html tile) :: curr_line),
         result
      )

get_tiles_html : (
      Int ->
      (Array.Array Battlemap.Tile.Type) ->
      (Html.Html Event.Type)
   )
get_tiles_html bmap_width tiles_array =
   let
      max_index = (bmap_width - 1)
      (_, last_line, other_lines) =
         (Array.foldr
            (get_tiles_lines_html max_index)
            (max_index, [], [])
            tiles_array
         )
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-tiles-layer")
         ]
         ((get_tiles_line_html last_line) :: other_lines)
      )
--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Battlemap.Type ->
      Float ->
      (List Character.Type) ->
      (Html.Html Event.Type)
   )
get_html battlemap scale characters =
   (Html.div
      [
         (Html.Attributes.class "battlemap-actual"),
         (Html.Attributes.style
            [
               (
                  "transform",
                  ("scale(" ++ (toString scale) ++ ")")
               )
            ]
         )
      ]
      (
         (Html.Lazy.lazy
            (get_tiles_html (Battlemap.get_width battlemap))
            (Battlemap.get_tiles battlemap)
         )
         ::
         (List.map
            (char_on_map)
            characters
         )
         ++
         case (Battlemap.try_getting_navigator_summary battlemap) of
            (Just nav_summary) ->
               (View.Battlemap.Navigator.get_html nav_summary)

            Nothing -> [(Util.Html.nothing)]
      )
   )
