module View.Map exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

import List

-- Map -------------------------------------------------------------------------
import Constants.UI

import Struct.Event
import Struct.Map
import Struct.Model
import Struct.Toolbox
import Struct.UI

import Util.Html

import View.Map.Tile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_tiles_html : (
      Struct.Toolbox.Type ->
      Struct.Map.Type ->
      (Html.Html Struct.Event.Type)
   )
get_tiles_html tb map =
   (Html.div
      [
         (Html.Attributes.class "map-tiles-layer"),
         (Html.Attributes.style
            [
               (
                  "width",
                  (
                     (toString
                        (
                           (Struct.Map.get_width map)
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
                           (Struct.Map.get_height map)
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
         (View.Map.Tile.get_html tb)
         (Array.toList (Struct.Map.get_tiles map))
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
         (Html.Attributes.class "map-actual"),
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
         (Html.Lazy.lazy2 (get_tiles_html) model.toolbox model.map)
      ]
   )