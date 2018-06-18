module View.Battlemap exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

import List

-- Battlemap -------------------------------------------------------------------
import Constants.UI

import Struct.Battlemap
import Struct.Character
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.UI

import Util.Html

import View.Battlemap.Character
import View.Battlemap.Navigator
import View.Battlemap.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_tiles_html : Struct.Battlemap.Type -> (Html.Html Struct.Event.Type)
get_tiles_html battlemap =
   (Html.div
      [
         (Html.Attributes.class "battlemap-tiles-layer"),
         (Html.Attributes.style
            [
               (
                  "width",
                  (
                     (toString
                        (
                           (Struct.Battlemap.get_width battlemap)
                           * Constants.UI.tile_size
                        )
                     )
                     ++ "px"
                  )
               ),
               (
                  "height",
                  (
                     (toString
                        (
                           (Struct.Battlemap.get_height battlemap)
                           * Constants.UI.tile_size
                        )
                     )
                     ++ "px"
                  )
               )
            ]
         )
      ]
      (List.map
         (View.Battlemap.Tile.get_html)
         (Array.toList (Struct.Battlemap.get_tiles battlemap))
      )
   )

maybe_print_navigator : (
      Bool ->
      (Maybe Struct.Navigator.Type) ->
      (Html.Html Struct.Event.Type)
   )
maybe_print_navigator interactive maybe_nav =
   let
      name_suffix =
         if (interactive)
         then
            "interactive"
         else
            "non-interactive"
   in
      case maybe_nav of
         (Just nav) ->
            (Html.div
               [
                  (Html.Attributes.class ("battlemap-navigator" ++ name_suffix))
               ]
               (View.Battlemap.Navigator.get_html
                  (Struct.Navigator.get_summary nav)
                  interactive
               )
            )

         Nothing ->
            (Util.Html.nothing)

get_characters_html : (
      Struct.Model.Type ->
      (Array.Array Struct.Character.Type) ->
      (Html.Html Struct.Event.Type)
   )
get_characters_html model characters =
   (Html.div
      [
         (Html.Attributes.class "battlemap-characters")
      ]
      (List.map
         (View.Battlemap.Character.get_html model)
         (Array.toList model.characters)
      )
   )

--------------------------------------------------------------------------------
-- EXPORTED --------------------------------------------------------------------
--------------------------------------------------------------------------------
get_html : (
      Struct.Model.Type ->
      (Html.Html Struct.Event.Type)
   )
get_html model =
   (Html.div
      [
         (Html.Attributes.class "battlemap-actual"),
         (Html.Attributes.style
            (
               if ((Struct.UI.get_zoom_level model.ui) == 1)
               then []
               else
                  [
                     (
                        "transform",
                        (
                           "scale("
                           ++
                           (toString (Struct.UI.get_zoom_level model.ui))
                           ++ ")"
                        )
                     )
                  ]
            )
         )
      ]
      [
         (Html.Lazy.lazy (get_tiles_html) model.battlemap),
         -- Not in lazy mode, because I can't easily get rid of that 'model'
         -- parameter.
         (get_characters_html model model.characters),
         (Html.Lazy.lazy2
            (maybe_print_navigator)
            True
            model.char_turn.navigator
         ),
         (Html.Lazy.lazy2
            (maybe_print_navigator)
            False
            (Struct.UI.try_getting_displayed_nav model.ui)
         )
      ]
   )
