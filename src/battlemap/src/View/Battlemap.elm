module View.Battlemap exposing (get_html)

import Array

import List

import Html
import Html.Attributes
import Html.Events

import Battlemap

import Character

import View.Battlemap.Tile
import View.Battlemap.Navigator

import Event
--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
char_on_map : Int -> Character.Type -> (Html.Html Event.Type)
char_on_map tile_size char =
   let
      char_loc = (Character.get_location char)
   in
      (Html.div
         [
            (Html.Attributes.class "battlemap-character-icon"),
            (Html.Attributes.class
               ("asset-character-icon-" ++ (Character.get_icon_id char))
            ),
            (Html.Events.onClick
               (Event.CharacterSelected (Character.get_ref char))
            ),
            (Html.Attributes.style
               [
                  ("top", ((toString (char_loc.y * tile_size)) ++ "px")),
                  ("left", ((toString (char_loc.x * tile_size)) ++ "px"))
               ]
            )
         ]
         [
         ]
      )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Battlemap.Type ->
      Int ->
      (List Character.Type) ->
      (Html.Html Event.Type)
   )
get_html battlemap tile_size characters =
   (Html.div
      [
         (Html.Attributes.class "battlemap-container")
      ]
      (
         (List.map
            (View.Battlemap.Tile.get_html tile_size)
            (Array.toList (Battlemap.get_tiles battlemap))
         )
         ++
         (List.map
            (char_on_map tile_size)
            characters
         )
         ++
         case (Battlemap.try_getting_navigator_summary battlemap) of
            (Just nav_summary) ->
               (View.Battlemap.Navigator.get_html tile_size nav_summary)

            Nothing -> [(Html.text "")]
      )
   )
