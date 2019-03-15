module View.Map exposing (get_html)

-- Elm -------------------------------------------------------------------------
import Array

import Html
import Html.Attributes
import Html.Lazy

import List

-- Battle Map ------------------------------------------------------------------
import BattleMap.Struct.Map

-- Local Module ----------------------------------------------------------------
import Constants.UI

import Struct.Event
import Struct.Model
import Struct.Toolbox
import Struct.UI

import View.SelectableTile

--------------------------------------------------------------------------------
-- LOCAL -----------------------------------------------------------------------
--------------------------------------------------------------------------------
get_tiles_html : (
      Struct.Toolbox.Type ->
      BattleMap.Struct.Map.Type ->
      (Html.Html Struct.Event.Type)
   )
get_tiles_html tb map =
   (Html.div
      [
         (Html.Attributes.class "tiles-layer"),
         (Html.Attributes.style
            "width"
            (
               (String.fromInt
                  (
                     (BattleMap.Struct.Map.get_width map)
                     * Constants.UI.tile_size
                  )
               )
               ++ "px"
            )
         ),
         (Html.Attributes.style
            "height"
            (
               (String.fromInt
                  (
                     (BattleMap.Struct.Map.get_height map)
                     * Constants.UI.tile_size
                  )
               )
               ++ "px"
            )
         )
      ]
      (List.map
         (View.SelectableTile.get_html False tb)
         (Array.toList (BattleMap.Struct.Map.get_tiles map))
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
            "transform"
            (
               if ((Struct.UI.get_zoom_level model.ui) == 1)
               then ""
               else
                  (
                     "scale("
                     ++
                     (String.fromFloat (Struct.UI.get_zoom_level model.ui))
                     ++ ")"
                  )
            )
         )
      ]
      [
         (Html.Lazy.lazy2 (get_tiles_html) model.toolbox model.map)
      ]
   )
