module View.Battlemap exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Dict

import Html
import Html.Attributes
import Html.Lazy

import List

-- Battlemap -------------------------------------------------------------------
import Constants.UI

import Struct.Battlemap
import Struct.CharacterTurn
import Struct.Event
import Struct.Model
import Struct.Navigator
import Struct.Tile
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
      (
         (Html.Lazy.lazy (get_tiles_html) model.battlemap)
         ::
         (List.map
            (View.Battlemap.Character.get_html)
            (Dict.values model.characters)
         )
         ++
         case (Struct.CharacterTurn.try_getting_navigator model.char_turn) of
            (Just navigator) ->
               (View.Battlemap.Navigator.get_html
                  (Struct.Navigator.get_summary navigator)
                  True
               )

            Nothing ->
               [(Util.Html.nothing)]
      )
   )
